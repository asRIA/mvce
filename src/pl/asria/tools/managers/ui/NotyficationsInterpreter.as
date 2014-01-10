package pl.asria.tools.managers.ui 
{
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class NotyficationsInterpreter 
	{
		
		public function NotyficationsInterpreter() 
		{
			
		}
		
		public function interprete(type:String):void 
		{
			throw new Error("If you want to use Notyfications Manager, please to override this class and set interpreter");
		}
		
	}

}