defmodule Servy.Handler do
  alias Servy.Conv

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.Router, only: [route: 1]

  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

#1st line in request is requestline with (method, path, protocol)
#2nd (host: domain)
#3rd (User-Agent: user agent)
#4th (Accept: media-type)
#5th (blank line is body)

# RESPONSE
#1st line in response is statusline (protocol, status code, reason phrase)
#2nd line in response is response headers (Content-Type: text/html)
#3rd line in response is Content Length
#4th line is blank line that separates headers to body
#5th line is the response body


response = Servy.Handler.handle(request)

IO.puts response
