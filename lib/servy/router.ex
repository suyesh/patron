defmodule Servy.Router do
  alias Servy.Conv

  @pages_path Path.expand("../../pages", __DIR__)

  import Servy.FileHandler, only: [handle_file: 2]

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %Conv{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    %Conv{ conv | status: 200, resp_body: "Teddy, Smokey, Paddington" }
  end

  #name=Baloo&type=Brown
  def route(%Conv{method: "GET", path: "/bears/" <> id } = conv) do
    params = %{"name" => "Baloo", "type" => "Brown"}
    %Conv{ conv | status: 200, resp_body: "Bear #{id}"}
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    %Conv{conv | status: 201, resp_body: "Create a bear!"}
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
      @pages_path
      |> Path.join("about.html")
      |> File.read
      |> handle_file(conv)
  end

  def route(%Conv{path: path} = conv) do
    %Conv{ conv | status: 404, resp_body: "No #{path} here!"}
  end
end
