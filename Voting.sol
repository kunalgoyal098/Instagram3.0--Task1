// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract VotingSystem{
   

    uint public id=0;

    uint public constant max_candidates = 8;

    struct Candidate{
        uint candidateid;
        string name;
        uint voteCount;
    }

    mapping(address => bool) hasVoted; 

    Candidate[max_candidates] public Candidatelist; 

    function registerCandidate(string memory _Name) public {

        require(id<max_candidates, "Max candidates reached");

        Candidatelist[id] = Candidate(id,_Name,0);
        id++;
    }

    function voting(uint _cid) public {
        require(0 <= _cid && _cid < max_candidates, "Invalid Candidate ID");
       
        Candidatelist[_cid].voteCount++;
    }

    function determineWinner() public view returns(string memory _Conclusion){
       
        bool tie = false;
        uint winner_voteCount = 0;

        uint winner_cid = max_candidates;

        for (uint i=0;i<id;i++){ 

            if (Candidatelist[i].voteCount>winner_voteCount){
                winner_voteCount=Candidatelist[i].voteCount;

                winner_cid = Candidatelist[i].candidateid; 

                tie = false;
            }
            else if (Candidatelist[i].voteCount==winner_voteCount){
                tie = true;
            }
        }
        if (winner_cid==max_candidates){
            _Conclusion = "No one has cast their vote yet!";
        }
        else if (tie){
            bool isFirst = true;

            bytes memory tempBytes;

            for (uint i=0;i<id;i++){

                if (Candidatelist[i].voteCount==winner_voteCount){

                    if (!isFirst){

                        tempBytes = abi.encodePacked(tempBytes,",");
                    }
                    else {

                        isFirst = false;
                    }
                    tempBytes = abi.encodePacked(tempBytes,bytes(Candidatelist[i].name));
                }
            }
            _Conclusion = string(abi.encodePacked("Tie between Candidates ",string(tempBytes)));
        }
        else{
            _Conclusion = string(abi.encodePacked(Candidatelist[winner_cid].name," has won"));
        }
    }


}