defmodule Phoenix.LiveView.FlashTest do
  use ExUnit.Case, async: true

  alias Phoenix.LiveView.{Socket, Utils}
  alias Phoenix.LiveViewTest.Endpoint

  test "sign" do
    assert is_binary(Utils.sign_flash(Endpoint, %{"info" => "hi"}))
  end

  test "verify with valid flash token" do
    token = Utils.sign_flash(Endpoint, %{"info" => "hi"})
    assert Utils.verify_flash(Endpoint, token) == %{"info" => "hi"}
  end

  test "verify with invalid flash token" do
    assert Utils.verify_flash(Endpoint, "bad") == %{}
    assert Utils.verify_flash(Endpoint, nil) == %{}
  end

  test "clear_flash" do
    socket =
      %Socket{assigns: %{flash: %{}}}
      |> Utils.put_flash(:info, "msg")

    assert socket
           |> Utils.clear_flash()
           |> Utils.get_flash() == %{}

    assert socket
           |> Utils.clear_flash(:info)
           |> Utils.get_flash() == %{}

    assert socket
           |> Utils.clear_flash("info")
           |> Utils.get_flash() == %{}

    assert socket
           |> Utils.clear_flash("error")
           |> Utils.get_flash() == %{"info" => "msg"}

    assert socket
           |> Utils.clear_flash(nil)
           |> Utils.get_flash() == %{"info" => "msg"}
  end
end
