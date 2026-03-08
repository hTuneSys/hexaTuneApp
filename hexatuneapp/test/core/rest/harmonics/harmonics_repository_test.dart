// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/harmonics_repository.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/generate_harmonics_request.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('HarmonicsRepository', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late MockApiClient mockApiClient;
    late MockLogService mockLogService;
    late HarmonicsRepository repository;

    final assignmentJson = {
      'inventoryId': 'inv-001',
      'harmonicNumber': 42,
      'assignedAt': '2026-03-08T03:00:00Z',
    };

    final responseJson = {
      'requestId': 'req-abc-123',
      'totalAssigned': 2,
      'assignments': [
        assignmentJson,
        {
          'inventoryId': 'inv-002',
          'harmonicNumber': 43,
          'assignedAt': '2026-03-08T03:00:01Z',
        },
      ],
    };

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://test.api'));
      dioAdapter = DioAdapter(dio: dio);
      mockApiClient = MockApiClient();
      mockLogService = MockLogService();

      when(() => mockApiClient.dio).thenReturn(dio);
      when(
        () => mockLogService.debug(any(), category: any(named: 'category')),
      ).thenReturn(null);

      repository = HarmonicsRepository(mockApiClient, mockLogService);
    });

    group('generate', () {
      test('sends POST with inventoryIds and returns response', () async {
        dioAdapter.onPost(
          ApiEndpoints.harmonicsGenerate,
          (server) => server.reply(201, responseJson),
          data: {
            'inventoryIds': ['inv-001', 'inv-002'],
          },
        );

        final result = await repository.generate(
          const GenerateHarmonicsRequest(inventoryIds: ['inv-001', 'inv-002']),
        );

        expect(result.requestId, 'req-abc-123');
        expect(result.totalAssigned, 2);
        expect(result.assignments, hasLength(2));
        expect(result.assignments[0].inventoryId, 'inv-001');
        expect(result.assignments[0].harmonicNumber, 42);
        expect(result.assignments[1].inventoryId, 'inv-002');
        expect(result.assignments[1].harmonicNumber, 43);
      });

      test('sends POST with single inventoryId', () async {
        dioAdapter.onPost(
          ApiEndpoints.harmonicsGenerate,
          (server) => server.reply(201, {
            'requestId': 'req-single',
            'totalAssigned': 1,
            'assignments': [assignmentJson],
          }),
          data: {
            'inventoryIds': ['inv-001'],
          },
        );

        final result = await repository.generate(
          const GenerateHarmonicsRequest(inventoryIds: ['inv-001']),
        );

        expect(result.requestId, 'req-single');
        expect(result.totalAssigned, 1);
        expect(result.assignments, hasLength(1));
      });

      test('throws DioException on server error', () async {
        dioAdapter.onPost(
          ApiEndpoints.harmonicsGenerate,
          (server) => server.reply(500, {
            'type': 'https://httpstatuses.com/500',
            'title': 'Internal Server Error',
            'status': 500,
          }),
          data: {
            'inventoryIds': ['inv-001'],
          },
        );

        expect(
          () => repository.generate(
            const GenerateHarmonicsRequest(inventoryIds: ['inv-001']),
          ),
          throwsA(isA<DioException>()),
        );
      });

      test('throws DioException on conflict (409)', () async {
        dioAdapter.onPost(
          ApiEndpoints.harmonicsGenerate,
          (server) => server.reply(409, {
            'type': 'https://httpstatuses.com/409',
            'title': 'Conflict',
            'status': 409,
            'detail': 'All 100 harmonic numbers exhausted',
          }),
          data: {
            'inventoryIds': ['inv-001'],
          },
        );

        expect(
          () => repository.generate(
            const GenerateHarmonicsRequest(inventoryIds: ['inv-001']),
          ),
          throwsA(isA<DioException>()),
        );
      });

      test('logs the network call', () async {
        dioAdapter.onPost(
          ApiEndpoints.harmonicsGenerate,
          (server) => server.reply(201, responseJson),
          data: {
            'inventoryIds': ['inv-001'],
          },
        );

        await repository.generate(
          const GenerateHarmonicsRequest(inventoryIds: ['inv-001']),
        );

        verify(
          () => mockLogService.debug(
            'POST harmonics/generate',
            category: any(named: 'category'),
          ),
        ).called(1);
      });
    });
  });
}
