package pl.asria.tools.managers 
{
	/**
	 * ...
	 * @author Piotr Paczkowski
	 */
	public class KeyLockSemaphore 
	{
		protected var _locks:int;
		
		private var locks:Array = [];
		private var lockHistory:Array = [];
		
		public function lock(lockKey:Object):void
		{
			var index:int = locks.indexOf(lockKey)
			if ( index == -1)
			{
				locks.push(lockKey);
				if (CONFIG::debug)
				{
					lockHistory.push(lockKey);
				}
				_locks++;
			}
		}
		
		public function unlock(lockKey:Object):void
		{
			var index:int = locks.indexOf(lockKey)
			if ( index > -1)
			{
				locks.splice(index, 1);
				_locks--;
			}
		}
		
		public function unlockAll():void
		{
			locks.length = 0;
			lockHistory.length = 0;
			_locks = 0;
		}
		
		public function get isLocked():Boolean
		{
			return _locks > 0;
		}
		
		public function get isUnlocked():Boolean
		{
			return _locks == 0;
		}
		
		public function KeyLockSemaphore() 
		{
			
		}
		
	}

}