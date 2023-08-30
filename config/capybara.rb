Capybara.javascript_driver = :webkit
Capybara::Webkit.configure do |config|
    config.class.parent::Connection.send(:remove_const,:WEBKIT_SERVER_START_TIMEOUT)
    config.class.parent::Connection::WEBKIT_SERVER_START_TIMEOUT = 30
    config.allow_url("http://0.0.0.0:3000")
end