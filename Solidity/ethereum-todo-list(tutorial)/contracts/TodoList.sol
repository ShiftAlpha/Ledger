pragma solidity >=0.4.21 <0.6.0;

contract TodoList {
    uint public taskCount = 0; //count tasks

    struct Task { //structure: named task with attr
        uint id;
        string content;
        bool completed;
    }
    mapping(uint => Task) public tasks;//associative array:

//event trigger task created
    event TaskCreated(
    uint id,
    string content,
    bool completed
  );
  //event trigger task completed
  event TaskCompleted(
    uint id,
    bool completed
  );
    //function to create tasks
    function createTask(string memory  _content) public {
       taskCount ++;
       tasks[taskCount] = Task(taskCount, _content, false);//array
       emit TaskCreated(taskCount, _content, false);
    }
    //function to toggle completed
    function toggleCompleted(uint _id) public {
    Task memory _task = tasks[_id];
    _task.completed = !_task.completed;
    tasks[_id] = _task;
    emit TaskCompleted(_id, _task.completed);
  }
    constructor() public {
        createTask("Build Blockchain");
    }
}