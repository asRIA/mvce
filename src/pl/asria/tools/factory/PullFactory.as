package pl.asria.tools.factory 
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import pl.asria.tools.performance.GarbageCollector;
	
	
	/**
	 * ...
	 * @author trzeci.eu
	 */
	public final class PullFactory 
	{
		private static const _spaces:Dictionary = new Dictionary();
		static private var _vPendingToCleanGC:Vector.<Object> = new Vector.<Object>();
		static private const _dPendingToClean:Dictionary = new Dictionary();
		static private var _pendingObjects:int = 0;

		
		// static constuctor and register in GarbageCollector mechanizm
		{
			GarbageCollector.registerFlushGarbages(PullFactory.flushGC);
			GarbageCollector.registerGarbagesCollector(PullFactory.gc);
		}
		
		
		/**
		 * Collect all garbages
		 */
		public static function gc():void
		{
			if (_pendingObjects)
			{
				//trace("4:PullFactory.gc: "+_pendingObjects+" pending objects");
				var ts:int  = getTimer();
				for (var key:Object in _dPendingToClean) 
				{
					if (_dPendingToClean[key].timestamp < ts)
					{
						if (_dPendingToClean[key].onGC) // stack on vector pending for GC
						{
							trace("2:PullFactory.gc\t* " + key + "[" + _dPendingToClean[key].liblary.length + "] - pending for flush");
							_vPendingToCleanGC = _vPendingToCleanGC.concat(_dPendingToClean[key].liblary);
						}
						else
						{
							trace("4:PullFactory.gc\t* " + key + "[" + _dPendingToClean[key].liblary.length + "] - REMOVED");
							disposeVector(_dPendingToClean[key].liblary);
						}
						
						delete _dPendingToClean[key];
						_pendingObjects--;
					}
					else
					{
						//trace("0:\t*"+key+"["+ _dPendingToClean[key].liblary.length+"] delay: " + (_dPendingToClean[key].timestamp - ts)/1000,"s");
					}
				}
			}
		}
		
		/**
		 * Get count of specyfic objects
		 * @param	spaceFactory
		 * @param	key String or Class only!
		 * @return
		 */
		public static function checkPoolCount(spaceFactory:String, key:Object):int
		{
			if (!_spaces[spaceFactory]) return 0;
			if (!(key is Class) && !(key is String)) throw new Error("Not allowed key, only Class or String");
			if (!_spaces[spaceFactory][key]) return 0;
			return _spaces[spaceFactory][key].length;
			
		}
		/**
		 * This function is used to concentrrate objects in specyfic type in one place. This is usefull to create finite number of objects
		 * @param	spaceFactory separated PullFactory space, in each spaces you can dispose all nodes
		 * @param	object example object of PullFactory, if it is possible please to use IPullFactory
		 * @param	uniqueID not required, but in this ID you can pool or create some object
		 */
		public static function pool(spaceFactory:String, object:Object, uniqueID:String = null):void
		{
			var __liblary:Dictionary;
			if (!_spaces[spaceFactory])
			{
				_spaces[spaceFactory] = new Dictionary(true);
			}
			__liblary = _spaces[spaceFactory];
			
			
			var __key:Object = uniqueID != null ? uniqueID : Object(object).constructor;
			if (!__liblary[__key])
			{
				__liblary[__key] = new Vector.<Object>();	
			}
			//trace("PullFactory: pool object type", object, "key:", __key, "space", spaceFactory);
			if (object is IPullFactory) (object as IPullFactory).resetObject();
			
			__liblary[__key].push(object);
		}
		
		/**
		 * Create object in specyfic type, if in factory exist some object with this class or uniquID then get if from factory
		 * @param	spaceFactory separated PullFactory space, in each spaces you can dispose all nodes
		 * @param	classDefinition 
		 * @param	uniqueID not required, but in this ID you can pool or create some object. This parametar has highter priority in create new object
		 * @return	Obejct with specyfic class or uniqueID, but if uniqueID is not recognized in factory, return null. 
		 */
		public static function create(spaceFactory:String, classDefinition:Class, uniqueID:String = null):*
		{
			var __obejcts:Vector.<Object>;
			var __key:Object = uniqueID != null ? uniqueID : classDefinition;
			
			
			if (_dPendingToClean[__key]) // pending has highter priority
			{
				var result:Object =  _dPendingToClean[__key].liblary.pop();
				if (_dPendingToClean[__key].liblary.length)
				{
					_dPendingToClean[__key].timestamp = getTimer() + _dPendingToClean[__key].cleanAfter;
				}
				else
				{
					delete _dPendingToClean[__key];
					_pendingObjects--;
				}
				return result;
			}
				
				
			if (!_spaces[spaceFactory])
			{
				if (classDefinition) return new classDefinition();
				else return null;
			}
			
			if (uniqueID != null)
				__obejcts = _spaces[spaceFactory][uniqueID];
			else
				__obejcts = _spaces[spaceFactory][classDefinition];
			
			if (!__obejcts || !__obejcts.length)
			{
				
				if (uniqueID != null) 
				{
					//trace("PullFactory.create: not recognized key", uniqueID, "in factory");
					return null;
				}
				else 
				{
					//trace("PullFactory: generate new one");
					return new classDefinition();
				}
			}

			//trace("PullFactory: pool object");
			return __obejcts.pop();

		}
		
		/**
		 * 
		 * @param	spaceFactory
		 * @param	key	UID:String, or Class
		 */
		public static function disposeNodes(spaceFactory:String, key:Object, cleanAfterTime:int = 0, cleanOnTriggerGC:Boolean = false):void
		{
			var __liblary:Dictionary;
			if (!(key is Class) && !(key is String)) throw new Error("Not allowed key");
			if (!_spaces[spaceFactory])
			{
				trace("0:PullFactory: SpaceFactory called:", spaceFactory, "has no saved objects");
				return;
			}
			__liblary = _spaces[spaceFactory];
			if (__liblary[key])
			{
				trace("0:PullFactory: dispose", __liblary[key].length, "objects", "key:", key, __liblary[key].length?("type: " + __liblary[key][0]):"");
				
				if (cleanAfterTime)
				{
					var pendingDefinition:Object = { 
						onGC:cleanOnTriggerGC,  
						cleanAfter:cleanAfterTime,  
						timestamp:getTimer() + cleanAfterTime, 
						spaceFactory:spaceFactory
					}
						
					if (_dPendingToClean[key])
					{
						pendingDefinition.liblary = _dPendingToClean[key].liblary.concat(__liblary[key]);
					}
					else 
					{
						pendingDefinition.liblary = __liblary[key]
						_pendingObjects++;
					}
					
					_dPendingToClean[key] = pendingDefinition;
				}
				else
				{
					if (cleanOnTriggerGC) // stack on vector pending for GC
					{
						_vPendingToCleanGC = _vPendingToCleanGC.concat(__liblary[key]);
					}
					else
					{
						disposeVector(__liblary[key]);
					}
				}
				
				delete __liblary[key];
			}
		}
		
		static private function disposeVector(liblary:Vector.<Object>):void 
		{
			if (liblary)
			{
				for (var i:int = 0; i < liblary.length; i++) 
				{
					if (liblary[i] is IPullFactory) 
						(liblary[i] as IPullFactory).cleanPoolObject();
				}
			}
			
		}
		
		/**
		 * 
		 * @param	spaceFactory		Space with this key will be removed according to rest parameters
		 * @param	cleanAfterTime		after this time this memory will be realased. 
		 * @param	cleanOnTriggerGC	works with cleanAfterTime. So, if <code>true</code> then after some time this value will not clean, only after call PullFactory.flushGC(). This is happends
		 * 	because, in some moments we dont need, or we dont want to run this heavy operation
		 */
		public static function disposeSpaceFactory(spaceFactory:String, cleanAfterTime:int = 0, cleanOnTriggerGC:Boolean = false):void
		{
			if (!_spaces[spaceFactory])
			{
				trace("PullFactory: SpaceFactory called:", spaceFactory, "has no saved objects");
				return;
			}
			
			
			for (var key:Object in _spaces[spaceFactory])
			{
				disposeNodes(spaceFactory, key,cleanAfterTime, cleanOnTriggerGC);
				delete _spaces[spaceFactory][key];
			}
			delete _spaces[spaceFactory];
			
			//if(GarbageCollector.enabled) flushGC();
			
		}
		
		
		/**
		 * Clean nodes cumulated to this moment and release memory. It runs after disposeAllNodes, disposeSpaceFactory also
		 */
		public static function flushGC():void
		{
			if (_vPendingToCleanGC.length)
			{
				trace( "4:PullFactory.flushGC: clean", _vPendingToCleanGC.length,"nodes" );
				disposeVector(_vPendingToCleanGC);
				_vPendingToCleanGC = new Vector.<Object>();
			}
			
		}
		
		/**
		 * Clean all spaces in PullFactory. And run flushGC() if GarbageCollector.enabled is true, otherwise it pending for. You can manual run flushGC if you want. 
		 */
		public static function disposeAllNodes():void
		{
			for (var spaceFactory:String in _spaces)
			{
				disposeSpaceFactory(spaceFactory);
				delete _spaces[spaceFactory];
			}
			//if(GarbageCollector.enabled) flushGC();
		}
		
		public static function state():void
		{
			var result:String = "0:\**** POOL FACTORY STATE ****\n";
			var i:int;
			var len:int;
			for (var spaceFactory:String in _spaces)
			{
				i = 0;
				result += "1:space: \t" + spaceFactory + "\n";
				for (var classDefinition:Object in _spaces[spaceFactory])
				{
					len = _spaces[spaceFactory][classDefinition].length
					result += "0: " + String(i++) + ") count: " + len +"\tkey: "+classDefinition+ (len > 0?("\ttype:" + _spaces[spaceFactory][classDefinition][0] + "\n"):"\n");
				}
			}
			
			if (_pendingObjects)
			{
				result += "2: Pending to clean: " + _pendingObjects + "\n"
				var ts:int = getTimer();
				
				for (var key:Object in _dPendingToClean) 
				{
					result += "0: \t*" + key + "[" + _dPendingToClean[key].liblary.length + "] delay: " + ((_dPendingToClean[key].timestamp - ts) / 1000) + "s\n";
				}
			}
			
			
			result+= "2: Pending for GC: " + _vPendingToCleanGC.length + "\n"
			result += "0:__________________\n";
			trace(result);
			result = null;
		}
		
		
	}

}