class TestExceptionLocalizationHandler
  def call(exception, _locale, _key, _options)
    raise exception.message
  end
end
