package pl.asria.tools.display.windows 
{
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class WindowError extends Error
	{
		static public const WINDOW_ALREADY_EXIST:MessageError = new MessageError("Window already exist in system management, please register window only once", 0);
		static public const CONTENER_NULL:MessageError = new MessageError("Please use not null contener. for example: stage, or every displayObject",1)
		
		public function WindowError(message:*="", id:*=0) 
		{
			super(message, id);
		}
		
	}

}
internal class MessageError
{
	public var message:String;
	public var id:int;
	
	public function MessageError(message:String, id:int):void
	{
		this.id = id;
		this.message = message;
	}
	public function toString():String
	{
		return "#[" + id + "]: " + message;
	}
}