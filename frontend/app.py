# app.py
import time
import requests
import json
import streamlit as st

USER_NAME = "You"
ASSISTANT_NAME = "Assistant"

def main():

    initialize_session_state()
    
    st.title("ChatBot")

    setup_sidebar()

    display_conversation(st.session_state.chat_log)

    if user_msg := st.chat_input("ここにメッセージを入力"):
        display_message(USER_NAME, user_msg)
        message_logging(USER_NAME, user_msg)

        llm_response = llm_requests(user_msg)
        display_message(ASSISTANT_NAME, llm_response)
        message_logging(ASSISTANT_NAME, llm_response)

def llm_requests(message):
    response = requests.post(st.session_state.api_endpoint+"/chat", json={"message": message})
    response_body = response.json().get("body", {})
    print(response_body)
    if isinstance(response_body, str):
        # bodyがエスケープされたJSON文字列の場合は再度デコード
        response_body = json.loads(response_body)
    if response.status_code == 200:
        return response_body.get("response", "エラー: レスポンスに内容が含まれていません。")
    else:
        return f"{response.status_code}: {response.text}"
    # time.sleep(1)
    # response = "Sample Response"
    # return response

def setup_sidebar():
    with st.sidebar:
        # APIエンドポイントの入力フィールド
        api_endpoint = st.sidebar.text_input("APIエンドポイント", st.session_state.api_endpoint)

        # 入力されたAPIエンドポイントをセッションステートに保存
        if api_endpoint:
            st.session_state.api_endpoint = api_endpoint
        if not st.session_state.api_endpoint:
            st.error("APIエンドポイントが設定されていません。")

        # S3バケット名の入力フィールド
        s3_bucket = st.sidebar.text_input("S3バケット", st.session_state.s3_bucket)

        # 入力されたS3バケット名をセッションステートに保存
        if s3_bucket:
            st.session_state.s3_bucket = s3_bucket
        if not st.session_state.s3_bucket:
            st.error("S3バケットが設定されていません。")
            upload(True)
        else:
            upload(False)

def display_conversation(messages):
    """会話の表示"""
    for message in messages:
        display_message(message['sender'], message['message'])

def display_message(sender, message):
    with st.chat_message(sender):
        st.write(message)

def initialize_session_state():
    if 'chat_log' not in st.session_state:
        st.session_state.chat_log = []
    if 'api_endpoint' not in st.session_state:
        st.session_state.api_endpoint = ""
    if 's3_bucket' not in st.session_state:
        st.session_state.s3_bucket = ""

def message_logging(sender, message):
    log = {"sender": sender, "message": message}
    st.session_state.chat_log.append(log)

def upload(disabled=False):
    if st.button("Upload", disabled=disabled):
        st.write("Upload!")


if __name__ == "__main__":
    main()
