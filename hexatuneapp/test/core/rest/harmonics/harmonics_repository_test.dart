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

    final packetJson = {'value': 440, 'durationMs': 30000, 'isOneShot': false};

    final responseJson = {
      'requestId': 'req-abc-123',
      'generationType': 'Binaural',
      'sourceType': 'Formula',
      'sourceId': 'frm-001',
      'totalItems': 2,
      'sequence': [
        packetJson,
        {'value': 528, 'durationMs': 15000, 'isOneShot': true},
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
      test('sends POST with generation params and returns response', () async {
        dioAdapter.onPost(
          ApiEndpoints.harmonicsGenerate,
          (server) => server.reply(201, responseJson),
          data: {
            'generationType': 'Binaural',
            'sourceType': 'Formula',
            'sourceId': 'frm-001',
          },
        );

        final result = await repository.generate(
          const GenerateHarmonicsRequest(
            generationType: 'Binaural',
            sourceType: 'Formula',
            sourceId: 'frm-001',
          ),
        );

        expect(result.requestId, 'req-abc-123');
        expect(result.generationType, 'Binaural');
        expect(result.sourceType, 'Formula');
        expect(result.sourceId, 'frm-001');
        expect(result.totalItems, 2);
        expect(result.sequence, hasLength(2));
        expect(result.sequence[0].value, 440);
        expect(result.sequence[0].durationMs, 30000);
        expect(result.sequence[0].isOneShot, false);
        expect(result.sequence[1].value, 528);
        expect(result.sequence[1].isOneShot, true);
      });

      test('sends POST with single packet response', () async {
        dioAdapter.onPost(
          ApiEndpoints.harmonicsGenerate,
          (server) => server.reply(201, {
            'requestId': 'req-single',
            'generationType': 'Monaural',
            'sourceType': 'Formula',
            'sourceId': 'frm-002',
            'totalItems': 1,
            'sequence': [packetJson],
          }),
          data: {
            'generationType': 'Monaural',
            'sourceType': 'Formula',
            'sourceId': 'frm-002',
          },
        );

        final result = await repository.generate(
          const GenerateHarmonicsRequest(
            generationType: 'Monaural',
            sourceType: 'Formula',
            sourceId: 'frm-002',
          ),
        );

        expect(result.requestId, 'req-single');
        expect(result.totalItems, 1);
        expect(result.sequence, hasLength(1));
      });

      test('handles empty sequence for unsupported types', () async {
        dioAdapter.onPost(
          ApiEndpoints.harmonicsGenerate,
          (server) => server.reply(201, {
            'requestId': 'req-photonic',
            'generationType': 'Photonic',
            'sourceType': 'Formula',
            'sourceId': 'frm-003',
            'totalItems': 0,
            'sequence': [],
          }),
          data: {
            'generationType': 'Photonic',
            'sourceType': 'Formula',
            'sourceId': 'frm-003',
          },
        );

        final result = await repository.generate(
          const GenerateHarmonicsRequest(
            generationType: 'Photonic',
            sourceType: 'Formula',
            sourceId: 'frm-003',
          ),
        );

        expect(result.sequence, isEmpty);
        expect(result.totalItems, 0);
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
            'generationType': 'Binaural',
            'sourceType': 'Formula',
            'sourceId': 'frm-001',
          },
        );

        expect(
          () => repository.generate(
            const GenerateHarmonicsRequest(
              generationType: 'Binaural',
              sourceType: 'Formula',
              sourceId: 'frm-001',
            ),
          ),
          throwsA(isA<DioException>()),
        );
      });

      test('throws DioException on not found (404)', () async {
        dioAdapter.onPost(
          ApiEndpoints.harmonicsGenerate,
          (server) => server.reply(404, {
            'type': 'https://httpstatuses.com/404',
            'title': 'Not Found',
            'status': 404,
          }),
          data: {
            'generationType': 'Binaural',
            'sourceType': 'Formula',
            'sourceId': 'frm-missing',
          },
        );

        expect(
          () => repository.generate(
            const GenerateHarmonicsRequest(
              generationType: 'Binaural',
              sourceType: 'Formula',
              sourceId: 'frm-missing',
            ),
          ),
          throwsA(isA<DioException>()),
        );
      });

      test('logs the network call', () async {
        dioAdapter.onPost(
          ApiEndpoints.harmonicsGenerate,
          (server) => server.reply(201, responseJson),
          data: {
            'generationType': 'Binaural',
            'sourceType': 'Formula',
            'sourceId': 'frm-001',
          },
        );

        await repository.generate(
          const GenerateHarmonicsRequest(
            generationType: 'Binaural',
            sourceType: 'Formula',
            sourceId: 'frm-001',
          ),
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
