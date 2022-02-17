pragma solidity >= 0.4.22 < 0.9.0;

contract SyndicateLoan {
    struct Borrower {
        uint256 loanAmount;
        address addr;
    }
    
    struct Bank {
        bool isAdmin;
        uint256 riskLimit;
        address addr;
    }
    
    Borrower public borrower;
    
    Bank public adminBank;
    Bank[5] public banks;
    
    mapping(address => Bank) public bankDetails;
    uint counter = 0;
    
    constructor (uint256 _loanAmount, address _adminBankAddress) public {
        borrower = Borrower({loanAmount: _loanAmount, addr: msg.sender});
        adminBank = Bank({isAdmin: true, riskLimit: 20000, addr: _adminBankAddress});
        //banks[counter++] = adminBank; to remove as admin bank has its own variable
    }
    
    modifier onlyOwner {
        require(msg.sender == borrower.addr);
        _;
    }
    
    modifier onlyAdmin {
        require(msg.sender == adminBank.addr);
        _;
    }
    
    function regsiteradminBank(uint256 _riskLimit) public onlyAdmin {
        //banks[counter] = Bank({isAdmin:false, riskLimit: _riskLimit, addr: newBankAddress});
        adminBank.riskLimit = _riskLimit;
        bankDetails[adminBank.addr] = adminBank;
    }
    
    //can be called only by the admin bank mentioned by the owner
    function regsiterBank(uint256 _riskLimit /*,address newBankAddress*/) public /*onlyAdmin*/ {
        //banks[counter] = Bank({isAdmin:false, riskLimit: _riskLimit, addr: newBankAddress});
        banks[counter] = Bank({isAdmin:false, riskLimit: _riskLimit, addr: msg.sender});
        bankDetails[msg.sender] = banks[counter++];
    }
    
    function instantiateLoan() public onlyOwner payable{
        if(borrower.loanAmount > adminBank.riskLimit){
            //syndicate loan with other banks
            sortBanksWithRiskLimit();
            uint curr = adminBank.riskLimit;
            
            for(uint i = 1;i < 5;i++){
                // TODO: also need to store participating banks
                if(curr >= borrower.loanAmount)
                    break;
                curr += banks[i].riskLimit;
            }
        }
    }
    
    function sortBanksWithRiskLimit() {
        for(uint i = 1;i < 5;i++){
            for(uint j = i + 1;j < 5;j++){
                if(banks[j].riskLimit > banks[i].riskLimit){
                    uint temp = banks[j].riskLimit;
                    banks[j].riskLimit = banks[i].riskLimit;
                    banks[i].riskLimit = temp;
                }
            }
        }
    }
    
    // function validateAmount(uint256 amount) return (bool){
        
    // }
    
    
}