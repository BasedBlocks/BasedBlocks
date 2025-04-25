// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {SignatureChecker} from "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";

contract BasedBlocks is ERC20, Ownable, ERC20Permit {
    struct Block {
        uint256 id;
        uint256 prize;
        address miner;
    }

    struct Miner {
        bool registered;
        address referrer;
        uint256 level;
    }

    uint256 public constant MAX_SUPPLY = 210000000 * 1e18;
    uint256 public constant halvingPeriod = 210000;

    uint256 public constant firstReward = 500 * 1e18;
    uint256 public usdPerEth = 1700;
    uint256 public constant baseUpgradeUsd = 5;

    uint256 public MINE_FEE = 0.00006 ether;

    uint256 public gameBlock;
    uint256 public regMiner;
    address public VERIFIER_ADDRESS;
    address public liqWallet;
    address public burnWallet;

    mapping(address => uint256) public rPoint;
    mapping(address => uint256) public earned;
    mapping(bytes32 => bool) public usedSignatures;

    mapping(uint256 => Block) public minedBlocks;
    mapping(address => Miner) public miners;

    mapping(string => bool) public minedHashes;

    constructor(address initialOwner, address _verifier_address, address _liq, address _burn)
        ERC20("Based Blocks Satoshi Vision", "BBSV")
        Ownable(initialOwner)
        ERC20Permit("Based Blocks Satoshi Vision")
    {
        VERIFIER_ADDRESS = _verifier_address;
        liqWallet = _liq;
        burnWallet = _burn;
    }

    function setVerifierAddress(address _new_address) external onlyOwner {
        VERIFIER_ADDRESS = _new_address;
    }

    error SignatureIsUsed();
    error InvalidSignature();

    function _checkSignatureAndStore(string memory hash, bytes memory _signature) internal {
        if (usedSignatures[keccak256(_signature)]) revert SignatureIsUsed();

        bytes32 message = keccak256(abi.encodePacked(msg.sender, hash));

        if (
            !SignatureChecker.isValidSignatureNow(
                VERIFIER_ADDRESS,
                MessageHashUtils.toEthSignedMessageHash(message),
                _signature
            )
        ) revert InvalidSignature();

        usedSignatures[keccak256(_signature)] = true;
    }

    event MinerRegistered(address indexed miner, address indexed referrer, uint256 updatedReferrerPoints);
    event Received(address sender, uint amount);
    event MinerUpgraded(address indexed miner, uint256 level);
    event BlockMined(uint256 indexed blockId, address indexed miner, string hash, uint256 reward, uint256 totalEarned, address referrer, uint256 rPoints);


    function register(address referrer) external {
        require(!miners[msg.sender].registered, "Already registered");
        require(msg.sender != referrer, "Can't refer yourself");
        regMiner++;

        miners[msg.sender] = Miner({
            registered: true,
            referrer: referrer,
            level: 0
        });
        rPoint[referrer] = rPoint[referrer] + 5;
        emit MinerRegistered(msg.sender, referrer, rPoint[referrer]);
    }

    function upgrade() external payable {
        require(miners[msg.sender].registered, "Not registered");

        uint256 currentLevel = miners[msg.sender].level;
        uint256 requiredUsd = baseUpgradeUsd * (2**currentLevel); // 10, 20, 40, 80...
        uint256 requiredEth = (requiredUsd * 1 ether) / usdPerEth;

        require(msg.value >= requiredEth, "Insufficient ETH sent");

        miners[msg.sender].level++;

        emit MinerUpgraded(msg.sender, miners[msg.sender].level);
    }

    function mine(string memory hash, bytes memory _signature) external payable {
        _checkSignatureAndStore(hash, _signature);

        address minerAddress = msg.sender;
        require(miners[minerAddress].registered, "Miner not registered");
        require(msg.value >= MINE_FEE, "Insufficient fee sent");
        require(!minedHashes[hash], "Already mined");

        uint256 baseReward = getCurrentReward();
        uint256 level = miners[minerAddress].level;
        uint256 reward = baseReward + (baseReward * level * 40) / 100;

        require(totalSupply() + reward <= MAX_SUPPLY, "Max supply reached");

        _mint(minerAddress, reward);

        minedHashes[hash] = true;

        minedBlocks[gameBlock] = Block({
            id: gameBlock,
            prize: reward,
            miner: minerAddress
        });
        earned[minerAddress] = earned[minerAddress] + reward;

        address refer = miners[minerAddress].referrer;
        rPoint[refer] = rPoint[refer] + 1;

        emit BlockMined(gameBlock, minerAddress, hash, reward, earned[minerAddress], refer, rPoint[refer]);
        gameBlock++;
    }

    function getCurrentReward() public view returns (uint256) {
        uint256 halvings = gameBlock / halvingPeriod;
        if (halvings >= 64) return 0;
        return firstReward >> halvings;
    }

    function getNextLevelPrize(uint256 currentLevel) public view returns (uint256) {
        uint256 requiredUsd = baseUpgradeUsd * (2**currentLevel); // 10, 20, 40, 80...
        uint256 requiredEth = (requiredUsd * 1 ether) / usdPerEth;

        return requiredEth;
    }

    function getLevelReward(uint256 level) external view returns (uint256) {
        uint256 baseReward = getCurrentReward();
        uint256 reward = baseReward + (baseReward * level * 40) / 100;

        return reward;
    }

    function setMineFee(uint _newValue) external onlyOwner {
        MINE_FEE = _newValue;
    }

    function setEth(uint _newValue) external onlyOwner {
        usdPerEth = _newValue;
    }

    function withdraw() external payable onlyOwner {
        (bool sent, ) = liqWallet.call{value: address(this).balance/2}("");
        (bool sent2, ) = burnWallet.call{value: address(this).balance}("");
        if (!sent && !sent2) revert FailedToSendETH();
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    error FailedToSendETH();
}
