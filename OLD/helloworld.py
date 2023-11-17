# helloworld.py

def app(environ, start_response):
    status = '200 OK'
    headers = [('Content-type', 'text/plain')]
    start_response(status, headers)

    # Return the response body as bytes
    return [b'Hello, World!\n']
