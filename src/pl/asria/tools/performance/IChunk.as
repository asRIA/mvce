package pl.asria.tools.performance 
{
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public interface IChunk 
	{
		/**
		 * Reset storage variables.
		 */
		function resetChunk():void;
		
		/**
		 * Every update of chunk should make some progres in interations over the loop. Every interate variables like: i,j,k,n... should be storage in local class.
		 * @return false if this was last calculate in loop/loops. in other case true
		 */
		function updateChunk():Boolean;
		
		/**
		 * For better debugging
		 */
		function get chunkName():String
	}
	
}