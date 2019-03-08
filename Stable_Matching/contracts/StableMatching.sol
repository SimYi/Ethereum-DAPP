pragma solidity >=0.4.21 <0.6.0;

//任务类型:城市道路交通状况数据感知
//稳定匹配:感知任务和工人之间匹配
//任务属性:任务ID、任务位置、偏序表、（报酬、任务截止时间）
//工人属性:工人ID、当前位置、偏序表、（信用度、设备评分）
//任务对工人偏好度计算:简化，按位置远近排序
//工人对任务偏好度计算:按位置远近排序
contract StableMatching{
	//任务类型
	struct Task{
		uint taskID;
		uint taskLocation;
		//任务偏序变量
		uint[] preferences；
		//其他临时变量值
		uint tmp;
	}
	//工人类型
	struct Worker{
		uint workerID;
		uint workerLocation;
		//工人偏序变量
		uint[] preferences；
		//其他临时变量值
		uint tmp;
	}
	//所有任务
	Task[] tasks = new Task[](1); 
	//所有工人
	Worker[] workers = new Worker[](1); 
	//总的任务数量
	uint public taskNum = 0;
	//总的工人数量
	uint public workerNum = 0;
	//添加任务事件
	event AddTask(uint _taskNum);
	//添加工人事件
	event AddWorker(uint _workerNum);
	//构造函数
	//constructor() public {} 
	//任务添加函数
	function addTask(uint _taskLocation) public returns(bool){
		uint[] _preferences = new uint[](1);
		taskNum = tasks.push(Task({taskID: taskNum, taskLocation: _taskLocation, preferences: _preferences, tmp: 0})) ;
		emit AddTask(taskNum);
		return true;
	}
	//工人添加函数
	function addWorker(uint _workerLocation) public returns(bool){
		uint[] _preferences = new uint[](1);
		workerNum = workers.push(Task({workerID: workerNum, workerLocation: _workerLocation, preferences: _preferences, tmp: 0}));
		emit AddWorker(workerNum);
		return true;
	}
	//任务偏序表计算函数
	function taskPerfrencesFunc() internal {
		for (uint i = 0; i < taskNum; i++) {
			for(uint j = 0; j < workerNum; j++){
				if(tasks)
			}
		}
	}
	//工人偏序表计算函数
	function workerPerferencesFunc() internal {}
	//稳定匹配主函数
}