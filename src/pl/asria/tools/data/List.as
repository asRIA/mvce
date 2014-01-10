package pl.asria.tools.data 
{
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class List
	{
		private var _root:ListNode;
		private var _tail:ListNode;
		private var _listLength:int = 0;
		public var seek:ListNode;
		public function List(rootNode:ListNode =null) 
		{
			_root = rootNode;
			if (_root)
			{
				rootNode.nodePreviously = null;
				while (rootNode)
				{
					rootNode.list = this;
					if (rootNode.isNodeTail)
						_tail = rootNode;
					rootNode = rootNode.nodeNext;
					
				}
			}
			
		}
		
		/* INTERFACE pl.asria.tools.data.List */
		
		public function get nodeRoot():ListNode 
		{
			return _root;
		}
		
		
		/**
		 * Conenct two lists, second list are cleaned
		 * @param	list
		 */
		public function listConcat(list:List):void 
		{
			_listLength += list.listLength;
			
			if (list.listLength>0)
			{
				var node:ListNode = list.nodeRoot;
				
				// rewrite list reference in nodes
				while (node)
				{
					node.list = this;
					node = node.nodeNext;
				}
				
				list.nodeRoot.nodePreviously = _tail;
				_tail.nodeNext = list.nodeRoot;
				_tail = list.nodeTail;
				list.listRemove(false);
			}
			
		}
		
		/**
		 * Clean list references
		 * @param	cleanNodes Flag to clean references in nodes (if not list structure between nodes is saved)
		 */
		public function listRemove(cleanNodes:Boolean = true):void 
		{
			//trace("list remove");
			if (cleanNodes)
			{
				var node:ListNode;
				var nodeNext:ListNode;
				nodeNext = _root;
				node = _root;
				while (nodeNext)
				{
					nodeNext = node.nodeNext
					node.nodeClean();
				}
			}
			
			_root = null;
			_tail = null;
			_listLength = 0;
		}
		
		public function listPop():ListNode 
		{
			//trace("list pop");
			var result:ListNode = _tail;
			if (seek && seek == _tail) seek = _tail.nodePreviously;
			if (_tail.nodePreviously)
			{
				_tail.nodePreviously.nodeNext = null;
				_tail = _tail.nodePreviously;
				if (_tail == _root) _tail.nodePreviously = null;
				_listLength--;
			}
			else
			{
				_root = null;
				_tail = null;
				_listLength = 0;
			}
			return result;
		}
		
		public function listPush(node:ListNode):void 
		{
			if (!_root) 
			{
				listUnshift(node);
				return;
			}
			_tail.nodeNext = node;
			node.nodePreviously = _tail;
			node.nodeNext = null;
			_tail = node;
			node.list = this;
			_listLength++;
		}
		
		public function listShift():ListNode 
		{
			var result:ListNode = _root;
			if (seek && seek == _root) seek = _root.nodeNext ;
			if (_root)
			{
				_root = _root.nodeNext;
				_root.nodePreviously = null;
				if (_tail == _root) _root.nodeNext = null;
				_listLength--;
			}
			else
			{
				_tail = null;
				_listLength = 0;
			}
			return result;

		}
		
		public function listUnshift(node:ListNode):void 
		{
			node.list = this;
			if (_root)
			{
				_root.nodePreviously = node;
			}
			else // mo first node - > no nodes
			{
				_tail = node;
			}
			_listLength++;
			node.nodeNext = _root; // can be null
			_root = node;
			_root.nodePreviously = null;
			
		}
		
		/* INTERFACE pl.asria.tools.data.List */
		
		/**
		 * 
		 * @param	node this node will be root of new one list
		 * @return
		 */
		public function listSplit(node:ListNode):List 
		{
			//trace("lust split");
			if (!isInList(node)) return null;
			else
			{
				if (node.isNodeRoot) return this;
				else
				{
					node.nodePreviously.nodeNext = null;
					_tail = node.nodePreviously;
					
					var newList:List = new List(node);
					newList.recalculateLength();
					recalculateLength();
					return newList;
				}
			}
		}
		
		/* INTERFACE pl.asria.tools.data.List */
		
		public function nodeRemove(node:ListNode):Boolean
		{
			//trace(" node remove");
			var _node:ListNode;
			if (node == _tail)
			{
				listPop();
				return true;
			}
			if (node == _root)
			{
				listShift();
				return true;
			}
			if (isInList(node))
			{
				if(seek && seek == node) seek = node.nodePreviously || node.nodeNext;
				node.nodeClean();
				_listLength--;
				return true;
			}
			return false;
		}
		
		/* INTERFACE pl.asria.tools.data.List */
		
		public function isInList(node:ListNode):Boolean 
		{
			var _node:ListNode = _root;
			while (_node)
			{
				if (_node == node) return true;
				_node = _node.nodeNext;
			}
			return false;
		}
		
		/* INTERFACE pl.asria.tools.data.List */
		
		public function nodeInsert(placeNode:ListNode, sourceNode:ListNode):void 
		{
			
			if (placeNode == null)
			{
				listPush(sourceNode);
				return;
			}
			
			if (_root == placeNode)
			{
				listUnshift(sourceNode);
				return;
			}
			if(isInList(placeNode))
			{
				sourceNode.list = this;
				sourceNode.nodePreviously = placeNode.nodePreviously;
				
				placeNode.nodePreviously.nodeNext = sourceNode;
				placeNode.nodePreviously = sourceNode;
				sourceNode.nodeNext = placeNode;
				_listLength++;
			}
			else throw new Error("placeNode is not on the list"+ placeNode+", "+ this+", "+ sourceNode);
			
			
		}
		public function recalculateLength():void
		{
			var node:ListNode = _root;
			_listLength = 0;
			while(node)
			{
				_listLength++;
				node = node.nodeNext;
			}
		}
		
		public function get nodeTail():ListNode 
		{
			return _tail;
		}
		
		
		public function get listLength():int 
		{
			return _listLength;
		}
		
	}

}