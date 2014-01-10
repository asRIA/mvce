package pl.asria.tools.factory 
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Piotr Paczkowski
	 */
	public class Factory 
	{
		public function Factory() 
		{
			
		}
		private static var liblary:Dictionary = new Dictionary();
		
		
		/**
		 * 
		 * @param	type name of class with package
		 * @param	cache save reference to last generated instance
		 * @return
		 */
		static public function generateObejct(type:String, cache:Boolean = false):*
		{
			if (cache && liblary[type] )
				return liblary[type];
			
			var bodyClass:Class;
			
			try {
				bodyClass = getDefinitionByName(type) as Class;
			}
			catch (e:Error){}
			
			if (!bodyClass) 
			{
				trace("Factory: not defined:", type,"class");
				return null;
			}
			var classDefinition:Object = new bodyClass as Object;
			if (cache) liblary[type] = classDefinition;
			
			return classDefinition;
		}
		
		/**
		 * clean cached defintions
		 */
		public static function clean():void
		{
			liblary = new Dictionary();
		}
	}

}