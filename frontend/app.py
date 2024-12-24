import time
import requests
import json
import streamlit as st

USER_NAME = "You"
ASSISTANT_NAME = "Assistant"
HTTP_OK = 200

def main():
    if 'initialized' not in st.session_state:
        initialize_session_state()
        st.session_state.initialized = True
    
    st.title("ChatBot")

    setup_sidebar()

    display_conversation(st.session_state.chat_log)

    if user_msg := st.chat_input("ここにメッセージを入力"):
        display_message(USER_NAME, user_msg)
        message_logging(USER_NAME, user_msg)

        with st.spinner("応答を生成中..."):
            llm_response = llm_requests(user_msg)
        display_message(ASSISTANT_NAME, llm_response)
        message_logging(ASSISTANT_NAME, llm_response)

def llm_requests(message):
    """LLM APIへのリクエストを送信し、レスポンスを処理する"""
    try:
        response = requests.post(st.session_state.api_endpoint+"/chat", json={"message": message})
        response.raise_for_status()  # HTTPエラーを例外として発生させる
        response_body = response.json().get("body")
        if response_body is None:
            return "エラー: レスポンスに body が含まれていません。"
        if isinstance(response_body, str):
            try:
                response_body = json.loads(response_body)
            except json.JSONDecodeError:
                return "エラー: レスポンス body の JSON デコードに失敗しました。"
        if response.status_code == HTTP_OK:
            return response_body.get("response", "エラー: レスポンスに内容が含まれていません。")
        else:
            return f"エラー: {response.status_code} - {response.text}"
    except requests.exceptions.RequestException as e:
        return f"エラー: リクエスト中にエラーが発生しました: {e}"

def setup_sidebar():
    """サイドバーの設定を行う"""
    with st.sidebar:
        # APIエンドポイントの入力フィールド
        api_endpoint = st.sidebar.text_input("APIエンドポイント", st.session_state.api_endpoint)

        # 入力されたAPIエンドポイントをセッションステートに保存
        if api_endpoint:
            st.session_state.api_endpoint = api_endpoint
        elif not st.session_state.api_endpoint and 'api_endpoint_error' not in st.session_state:
            st.error("APIエンドポイントが設定されていません。")
            st.session_state.api_endpoint_error = True

        # S3バケット名の入力フィールド
        s3_bucket = st.sidebar.text_input("S3バケット", st.session_state.s3_bucket)

        # 入力されたS3バケット名をセッションステートに保存
        if s3_bucket:
            st.session_state.s3_bucket = s3_bucket
        elif not st.session_state.s3_bucket and 's3_bucket_error' not in st.session_state:
            st.error("S3バケットが設定されていません。")
            st.session_state.s3_bucket_error = True
            upload(disabled=True)
        else:
            upload(disabled=False)

def display_conversation(messages):
    """会話の表示"""
    for message in messages:
        display_message(message['sender'], message['message'])

def display_message(sender, message):
    """メッセージを表示する"""
    with st.chat_message(sender):
        st.write(message)

def initialize_session_state():
    """セッションステートの初期化"""
    st.session_state.chat_log = []
    st.session_state.api_endpoint = ""
    st.session_state.s3_bucket = ""

def message_logging(sender, message):
    """メッセージをログに記録する"""
    log = {"sender": sender, "message": message}
    st.session_state.chat_log.append(log)

def upload(disabled=False):
    """S3へのアップロード処理を行う"""
    if st.button("Upload", disabled=disabled):
        st.write("Upload!")
        # ここにS3へのアップロード処理を実装する

if __name__ == "__main__":
    main()