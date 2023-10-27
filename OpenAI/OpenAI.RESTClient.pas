unit OpenAI.RESTClient;

interface

uses REST.Client, REST.Json, System.Json;

type
  TRESTClient = class(TCustomRESTClient)
  public
    function PostEntity<T>(const AResource: string; AEntity: T): TJSONObject;
  end;

implementation

function TRESTClient.PostEntity<T>(const AResource: string; AEntity: T): TJSONObject;
var
  LRequest: TRESTRequest;
begin
  LRequest := TRESTRequest.Create(Self);
  try
    LRequest.Method := 'POST';
    LRequest.Resource := AResource;
    LRequest.AddBody(AEntity);
    LRequest.Execute;
    if LRequest.Response.JSONValue <> nil then
      Result := LRequest.Response.JSONValue as TJSONObject;
  finally
    LRequest.Free;
  end;
end;

end.
