package pl.asria.tools.data 
{
	/**
	 * @version	1.2
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public interface IDump 
	{
		
		/**
		 * Load dump object into this object, alway take reference, please be carry about infiniti loops
		 * @param	objectJSON
		 */
		function loadDump(dump:Object):void;
		
		/**
		 * Make dump with every obejcts from refereceTable, if object has IDump interface then recursive IDump. Please be carry about infinity loops
		 * @return
		 */
		function saveDump():Object;
		
		
	}
	
}