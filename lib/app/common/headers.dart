const String OPEN_AI_KEY =
    "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";

const String baseURL = "https://api.openai.com/v1";

String endPoint(String endPoint) => "$baseURL/$endPoint";

Map<String, String> headerBearerOption(String token) => {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };

enum ApiState { loading, success, error, notFound }
