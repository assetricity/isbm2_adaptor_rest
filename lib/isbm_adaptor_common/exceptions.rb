module IsbmAdaptor

  class IsbmFault < RuntimeError
  end

  class ChannelFault < IsbmFault
  end

  class NamespaceFault < IsbmFault
  end

  class OperationFault < IsbmFault
  end

  class ParameterFault < IsbmFault
  end

  class SecurityTokenFault < IsbmFault
  end

  class SessionFault < IsbmFault
  end

  # Class of IsbmFault to use when an unexpecyed error or fault type is
  # returned by the ISBM server.
  class UnknownFault < IsbmFault
  end

end
