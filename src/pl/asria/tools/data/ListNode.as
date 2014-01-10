package pl.asria.tools.data 
{
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class ListNode
	{
		public var nodeNext:ListNode;
		public var nodePreviously:ListNode;
		public var list:List;
		
		public function ListNode() 
		{
		}
		
		/**
		 * Clean only properties in node. 
		 * @usage only from List class, this methot integrate with list structure
		 */
		public function nodeClean():void 
		{
			nodeNext = null;
			nodePreviously = null;
			list = null;
		}
		

		
		public function get isNodeTail():Boolean 
		{
			return nodeNext==null;
		}
		
		public function get isNodeRoot():Boolean 
		{
			return nodePreviously==null;
		}
		
		
	}

}