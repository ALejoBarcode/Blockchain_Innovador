// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Interfaz del contrato ERC20 para RSK
interface IERC20RSK {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract IntercambioSidechain {
    address public direccionTokenBitcoin; // Dirección del contrato del token en la mainchain de Bitcoin
    address public direccionTokenRSK; // Dirección del contrato del token en la sidechain de RSK

    // Evento para registrar una transferencia realizada
    event TransferenciaRealizada(address remitente, uint256 cantidadBitcoin, uint256 cantidadRSK);

    // Constructor que recibe las direcciones de los contratos de tokens
    constructor(address _direccionTokenBitcoin, address _direccionTokenRSK) {
        direccionTokenBitcoin = _direccionTokenBitcoin;
        direccionTokenRSK = _direccionTokenRSK;
    }

    // Función para intercambiar tokens entre mainchain y sidechain
    function intercambiarTokens(uint256 cantidadBitcoin) external {
        // Transferir tokens desde la mainchain de Bitcoin a la sidechain de RSK
        require(IERC20RSK(direccionTokenRSK).transfer(msg.sender, cantidadBitcoin), "Transferencia a RSK fallida");

        // Emitir evento de transferencia realizada
        emit TransferenciaRealizada(msg.sender, cantidadBitcoin, cantidadBitcoin);
    }

    // Función para consultar el saldo de tokens en la sidechain de RSK
    function saldoRSK() external view returns (uint256) {
        return IERC20RSK(direccionTokenRSK).balanceOf(address(this));
    }
}
