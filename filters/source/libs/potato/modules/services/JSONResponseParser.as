package potato.modules.services
{
	import potato.modules.services.IResponseParser;
	import com.brokenfunction.json.decodeJson;

	public class JSONResponseParser implements IResponseParser
	{
		public function get id():String
		{
			return "json";
		}
		
		public function parse(rawContent:String):*
		{
			try
			{
				return decodeJson( rawContent );
			}
			catch (e:Error)
			{
				trace("JSONResponse::parse() error", e.message);
				return null;
			}
		}
	}

}
