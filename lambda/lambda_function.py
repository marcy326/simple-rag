import json
import openai
from openai import OpenAI
import os


def lambda_handler(event, context):
    """
    Lambda関数のエントリポイント
    :param event: API Gatewayからのリクエストイベント
    :param context: Lambdaの実行コンテキスト
    :return: API Gatewayへのレスポンス
    """
    try:
        user_message = event.get("message", "")
        if not user_message:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Missing 'message' in request body"})
            }    

        client = OpenAI()
        # OpenAIのChat APIを呼び出し
        response = client.chat.completions.create(
            model="gpt-4o",  # 使用するモデル
            messages=[
                {"role": "system", "content": "あなたは役に立つアシスタントです。回答は必ず日本語で行ってください。"},
                {"role": "user", "content": user_message}
            ]
        )

        # ChatGPTのレスポンスを抽出
        chat_response = response.choices[0].message.content

        # 正常なレスポンスを返す
        return {
            "statusCode": 200,
            "body": json.dumps({"response": chat_response})
        }

    except Exception as e:
        # エラー発生時のレスポンス
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
