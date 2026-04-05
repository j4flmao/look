cask "look" do
  version "1.0.0"
  sha256 "9d03d144278b72d690af5c9e7b9964f847e17e1ac75e7bcec77260d92fede32d"

  url "https://github.com/kunkka19xx/look/releases/download/v#{version}/Look-#{version}-macOS.zip"
  name "look"
  desc "Keyboard-first local launcher for macOS"
  homepage "https://github.com/kunkka19xx/look"

  app "Look.app"
end
