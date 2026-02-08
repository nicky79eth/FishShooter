// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Somnia Fish Shooter
/// @author Nicky
/// @notice On-chain mini fish shooting game for Somnia ecosystem
contract FishShooter {
    uint256 public constant ENERGY_COST = 1;
    uint256 public constant INITIAL_ENERGY = 10;

    struct Player {
        uint256 energy;
        uint256 score;
    }

    struct Fish {
        uint256 hp;
        uint256 reward;
        bool alive;
    }

    mapping(address => Player) public players;
    mapping(uint256 => Fish) public fishes;

    uint256 public fishCounter;

    event FishSpawned(uint256 indexed fishId, uint256 hp, uint256 reward);
    event Shot(
        address indexed player,
        uint256 indexed fishId,
        uint256 damage,
        bool killed
    );
    event EnergyRefilled(address indexed player, uint256 amount);

    constructor() {
        _spawnFish(3, 5);
        _spawnFish(5, 10);
        _spawnFish(8, 20);
    }

    /* ---------------- PLAYER ---------------- */

    function _initPlayer(address player) internal {
        if (players[player].energy == 0) {
            players[player] = Player({
                energy: INITIAL_ENERGY,
                score: 0
            });
        }
    }

    function refillEnergy() external {
        Player storage p = players[msg.sender];
        p.energy += INITIAL_ENERGY;
        emit EnergyRefilled(msg.sender, INITIAL_ENERGY);
    }

    /* ---------------- GAME ---------------- */

    function shoot(uint256 fishId) external {
        _initPlayer(msg.sender);

        Player storage p = players[msg.sender];
        require(p.energy >= ENERGY_COST, "Not enough energy");

        Fish storage f = fishes[fishId];
        require(f.alive, "Fish not alive");

        p.energy -= ENERGY_COST;

        uint256 damage = _randomDamage();
        bool killed = false;

        if (damage >= f.hp) {
            p.score += f.reward;
            f.hp = 0;
            f.alive = false;
            killed = true;
        } else {
            f.hp -= damage;
        }

        emit Shot(msg.sender, fishId, damage, killed);
    }

    /* ---------------- ADMIN / SPAWN ---------------- */

    function _spawnFish(uint256 hp, uint256 reward) internal {
        fishes[fishCounter] = Fish({
            hp: hp,
            reward: reward,
            alive: true
        });

        emit FishSpawned(fishCounter, hp, reward);
        fishCounter++;
    }

    /* ---------------- RANDOM ---------------- */

    function _randomDamage() internal view returns (uint256) {
        return
            (uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.prevrandao,
                        msg.sender
                    )
                )
            ) % 3) + 1;
    }
}
