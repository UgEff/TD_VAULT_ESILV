// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "forge-std/Test.sol";
import "../src/my_MockERC20.sol";
import "../src/my_Vault.sol";



contract VaultAndTokenTest is Test {
    MockERC20 token;
    BasicVault vault;
    address user = address(1);

    function setUp() public {
        // Déployer le token et le coffre-fort avec un approvisionnement initial
        token = new MockERC20("MockToken", "MTK", 1e18);
        vault = new BasicVault(token);

        // Préparer l'environnement de test
        token.transfer(user, 1e18);
        vm.prank(user);
        token.approve(address(vault), 1e18);
    }

    function testDeposit() public {
        // Tester le dépôt
        uint256 initialBalance = token.balanceOf(user);
        uint256 depositAmount = 1e18;

        vm.prank(user);
        vault.deposit(depositAmount);

        assertEq(vault.balanceOf(user), depositAmount, "Le depot na pas ete enregistre correctement.");
        assertEq(token.balanceOf(user), initialBalance - depositAmount, "Le solde du token na pas ete deduit correctement.");
    }

    function testWithdraw() public {
        // Tester le retrait
        uint256 depositAmount = 1e18;
        vm.prank(user);
        vault.deposit(depositAmount);

        vm.prank(user);
        vault.withdraw(depositAmount);

        assertEq(vault.balanceOf(user), 0, "Le retrait na pas ete enregistre correctement.");
        assertEq(token.balanceOf(user), 1e18, "Le solde du token na pas ete restitue correctement.");
    }
}
