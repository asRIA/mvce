package pl.asria.tools.data 
{
	
	/**
	 * List data structure
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public interface IListNode 
	{
		function set list(value:IList):void;
		function get list():IList;
		function set nodePreviously(value:IListNode):void;
		function set nodeNext(value:IListNode):void;
		function get isNodeTail():Boolean;
		function get isNodeRoot():Boolean;
		/**
		 * Return next node of this list
		 */
		function get nodeNext():IListNode;
		/**
		 * Return previously node in this list
		 */
		function get nodePreviously():IListNode;
		
		/**
		 * Remove this node from list, list structure must be saved
		 */
		function nodeClean():void;

		
	}
	
}