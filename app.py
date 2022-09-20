from flask import Flask

app = Flask(__name__)

@app.route('/')
def root():
    return "Hello World! this is version 1"


if __name__ == "__main__":
    app.debug = True
    app.run(host="0.0.0.0", port=80)