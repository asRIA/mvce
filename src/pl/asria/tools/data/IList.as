package pl.asria.tools.data 
{
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public interface IList 
	{
		function get nodeRoot():IListNode;
		function get nodeTail():IListNode;
		
		/**
		 * Split list in this node
		 * @return root of second list
		 */
		function listSplit():IList

		/**
		 * Concatenate with second list
		 * @param	root Root of the other list
		 */
		function listConcat(list:IList):void
		
		/**
		 * This method should remove every references to nodes include: nodeNext, nodePrevious, nodeRoot, nodeTail
		 */
		function listRemove():void
		function listPop():IListNode;
		function listPush(node:IListNode):void;
		function listShift():IListNode;
		function listUnshift(node:IListNode):void;
		function get listLength():int;
		function nodeRemove(node:IListNode):Boolean;
		function isInList(node:IListNode):Boolean;
		
		/**
		 * Place node into list structure. 
		 * @param	placeNode if placeNode is null, then method works like listPush
		 * @param	sourceNode node to push
		 */
		function nodeInsert(placeNode:IListNode, sourceNode:IListNode):void;
	}
	
}