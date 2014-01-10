/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-12-09 22:44</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.factory 
{
	import flash.utils.Dictionary;
	import org.osflash.signals.Signal;
	
	public class BuilderQueue
	{
		protected var _vNodes:Vector.<EntryNode> = new Vector.<EntryNode>();
		protected var _maxProcessingNodes:int;
		protected var _lut:Dictionary = new Dictionary();
		protected var _processingNodes:int = 0;
		protected var _onComeplete:Signal = new Signal(BuilderQueue);
		protected var _isStarted:Boolean = false;
		protected var secondaryPriotity:int = 0;
	
		/**
		 * BuilderQueue - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function BuilderQueue(maxProcessingNodes:int = 1) 
		{
			_maxProcessingNodes = maxProcessingNodes;
		}
		
		public function register(factory:MegaFactory, description:Object, priority:int = 0):Signal 
		{
			var signal:Signal = new Signal(Boolean, MegaFactoryResult);
			var node:EntryNode = new EntryNode(factory, description, signal);
			node.priority = priority;
			node.secondaryPriotity = secondaryPriotity++;
			_vNodes.push(node);
			
			if (_isStarted)
			{
				sortNodes();
			}
			return signal;
		}
		
		protected function sortNodes():void 
		{
			// queue is poped!
			_vNodes = _vNodes.sort(EntryNode.comaprator);
		}
		
		public function start():void
		{
			if (!_isStarted) sortNodes();
			
			_isStarted = true;
			if (_processingNodes <= _maxProcessingNodes && _vNodes.length)
			{
				_processingNodes++;
				var currentNode:EntryNode = _vNodes.pop();
				currentNode.result = currentNode.factory.createAsync(currentNode.description);
				_lut[currentNode.result] = currentNode;
				
				if (currentNode.result.isComplete)
				{
					onNodeComplete(currentNode.result);
				}
				else
				{
					currentNode.result.onComplete.addOnce(onNodeComplete);
					currentNode.result.onFail.addOnce(onNodeFail);
				}
				
			}
		}
		
		protected function onNodeFail(result:MegaFactoryResult):void 
		{
			var node:EntryNode = _lut[result];
			node.signal.dispatch(false, result);
			delete _lut[result];
			_processingNodes--;
			nextTask();
		}
		
		protected function onNodeComplete(result:MegaFactoryResult):void 
		{
			var node:EntryNode = _lut[result];
			node.signal.dispatch(true, result);
			delete _lut[result];
			_processingNodes--;
			nextTask();
		}
		
		protected function nextTask():void 
		{
			if (_processingNodes == 0 && _vNodes.length == 0)
			{
				_onComeplete.dispatch(this);
			}
			else
			{
				start();
			}
		}
		
		public function get onComeplete():Signal 
		{
			return _onComeplete;
		}
		
	}
}

import org.osflash.signals.Signal;
import pl.asria.tools.factory.MegaFactory;
import pl.asria.tools.factory.MegaFactoryResult;
internal class EntryNode
{
	public var signal:Signal;
	public var description:Object;
	public var factory:MegaFactory;
	public var priority:int;
	public var result:MegaFactoryResult;
	public var secondaryPriotity:int;
	
	public static function comaprator(A:EntryNode, B:EntryNode):int
	{
		if (A.priority > B.priority) return 1;
		else if (A.priority < B.priority) return -1;
		return comapratorSecondary(A, B);
	}
	public static function comapratorSecondary(A:EntryNode, B:EntryNode):int
	{
		if (A.secondaryPriotity > B.secondaryPriotity) return -1;
		else if (A.secondaryPriotity < B.secondaryPriotity) return 1;
		return 0;
	}
	public function EntryNode(factory:MegaFactory, description:Object, signal:Signal)
	{
		this.signal = signal;
		this.description = description;
		this.factory = factory;
		
	}
}