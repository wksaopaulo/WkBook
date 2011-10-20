package potato.modules.services
{
	import potato.modules.services.ICallEncoder;
	import potato.modules.log.log;
	
	import com.brokenfunction.json.encodeJson;

	public class JSONCallEncoder implements ICallEncoder
	{
		public function get id():String
		{
			return "json";
		}
		
		public function encode(value:*):String
		{
			try
			{
				return encodeJson( value );
			}
			catch (e:Error)
			{
				log("JSONCallEncoder::encode() error", e.message);
				return null;
			}
			return null;
		}
	}
}
