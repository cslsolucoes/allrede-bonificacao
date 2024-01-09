object DataModule1: TDataModule1
  Height = 480
  Width = 640
  object RESTClient1: TRESTClient
    BaseURL = 
      'https://api.allrede.hubsoft.com.br/api/v2/login?username=paineld' +
      'evagas@api.com.br&password=Y*H4swkUsh$5ODw&origem=web'
    Params = <>
    SynchronizedEvents = False
    Left = 152
    Top = 192
  end
  object RESTRequest1: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient1
    Method = rmPOST
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 288
    Top = 200
  end
  object RESTResponse1: TRESTResponse
    Left = 456
    Top = 208
  end
end
