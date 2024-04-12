// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Importar la interfaz del contrato ERC20 de Ethereum
import "./IERC20.sol";

contract IntercambioInteroperable {
    // Dirección del contrato del token ERC20 en Ethereum
    address public direccionTokenEthereum;

    // Dirección del contrato del token BEP20 en Binance Smart Chain
    address public direccionTokenBSC;

    // Evento para notificar cuando se complete un intercambio
    event IntercambioRealizado(address remitente, uint256 cantidad);

    // Constructor que recibe las direcciones de los contratos de tokens
    constructor(address _direccionTokenEthereum, address _direccionTokenBSC) {
        direccionTokenEthereum = _direccionTokenEthereum;
        direccionTokenBSC = _direccionTokenBSC;
    }

    // Función para intercambiar tokens ERC20 por tokens BEP20
    function intercambiarTokens(uint256 cantidad) public {
        // Transferir tokens ERC20 desde la cuenta del remitente al contrato
        IERC20(direccionTokenEthereum).transferFrom(msg.sender, address(this), cantidad);

        // Emitir evento de intercambio realizado
        emit IntercambioRealizado(msg.sender, cantidad);

        // Transferir tokens BEP20 desde el contrato a la cuenta del remitente
        IERC20(direccionTokenBSC).transfer(msg.sender, cantidad);
    }
}
