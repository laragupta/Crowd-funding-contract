pragma solidity ^0.8.0;
contract Crowdfunding {
    mapping (address=>uint) public contributors;
    uint public target;
    uint public deadline;
    address public manager;
    uint public minContribution;
    uint public raisedAmount;
    uint  public noOfContributor;
    uint  public numRequest;

    constructor ( uint _deadline, uint _target) {
        manager=msg.sender;
        target=_target;
        deadline=block.timestamp+_deadline;
        minContribution=100 wei;

        
    }
    function sendEther() public payable {
        require(block.timestamp<deadline,"Deadline has passed");
        require(raisedAmount<target,"target has reached");
        require(msg.value>=minContribution,"Not Sufficient Amount");
        if(contributors[msg.sender]==0){
            noOfContributor++;
        }
        contributors[msg.sender]+=msg.value;
        raisedAmount+=msg.value;

    }
    struct request {
        string  description;
        uint  value;
        uint  noOfVoters;
        address payable recepients;
        mapping(address=>bool)  voters;
        bool  completed;


    }
    mapping(uint=>request) public requests;
    function createRequest(string memory _description , uint _value,address payable recepients) public {
         require(msg.sender== manager);
        request storage newRequest = requests[numRequest];
        numRequest++;
        newRequest.description=_description;
        newRequest.value=_value;
        newRequest.completed=false;
       newRequest.noOfVoters=0;
        newRequest.recepients=recepients;

    }

    function voting (uint _request)public{ 
        require(contributors[msg.sender]>0,"you are not eligible for voting");
        request storage thisRequest =requests[_request];
        require(thisRequest.voters[msg.sender]==false,"You have already Voted");
        thisRequest.voters[msg.sender]=true;
        thisRequest.noOfVoters++;
    }
    function makePayment (uint _No ) public {
        require(raisedAmount >= target, "Target not reached yet");
        require(msg.sender==manager);
        request storage thisRequest =requests[_No];
        require(thisRequest.completed==false,"The request has been completed");
        require(thisRequest.noOfVoters>noOfContributor/2,"Majority does not support you");
        thisRequest.recepients.transfer(thisRequest.value);
        thisRequest.completed=true;

    }

    


} 
