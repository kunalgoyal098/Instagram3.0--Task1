// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract AadharCard{
  

    address public owner;

    constructor(){
        owner = msg.sender;
    }

    modifier Owner() {
        require( msg.sender == owner , "Only Owner executesfunction");
        _; 
    }

    struct AadharDetails{
        string name;
        string dob; 
        string addressInfo;
        address walletAddress;
        bool Registeredornot;
    }

    mapping(address => AadharDetails) private userDetails; 

    function isValidDob(string memory _Dob) private pure returns(bool){
        bytes memory dob = bytes(_Dob);
        if (dob.length != 10){return false;}
        for (uint i=0;i<10;i++){
            if (i==2 || i==5){
                if (dob[i]!='-'){return false;} // Dob is given in the format od dd-mm-yyyy
            }
            else{
                if (dob[i]>'9' || dob[i]<'0') {return false;}
            }
        }
        return true;
    }

    function storeAadharDetails(string memory _Name, string memory _Dob, string memory _AddressInfo) public {
        require(!userDetails[msg.sender].Registeredornot, "User-registered");
        require(isValidDob(_Dob),"Not a valid date format");
        userDetails[msg.sender] = AadharDetails(_Name,_Dob,_AddressInfo,msg.sender,true);
    }

    function getAadharDetails() view public returns(string memory, string memory, string memory, address) {
        require(userDetails[msg.sender].Registeredornot, "User not registered");
        AadharDetails memory user = userDetails[msg.sender];
        return (user.name, user.dob, user.addressInfo, user.walletAddress);
    }

    function getAadharDetails(address _WalletAddress) view public onlyOwner returns(string memory, string memory, string memory, address) {

        require(userDetails[_WalletAddress].Registeredornot, "User not registered");
        AadharDetails memory user = userDetails[_WalletAddress];
        return (user.name, user.dob, user.addressInfo, user.walletAddress);
    }

}