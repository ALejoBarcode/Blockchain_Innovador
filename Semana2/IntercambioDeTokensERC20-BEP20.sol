// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Interfaz del contrato ERC20 para Ethereum
interface IERC20Ethereum {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}

// Interfaz del contrato BEP20 para Binance Smart Chain
interface IERC20BSC {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract IntercambioInteroperable {
    address public direccionTokenEthereum; // Dirección del contrato del token ERC20 en Ethereum
    address public direccionTokenBSC; // Dirección del contrato del token BEP20 en Binance Smart Chain

    // Evento para registrar un intercambio realizado
    event IntercambioRealizado(address remitente, uint256 cantidadEthereum, uint256 cantidadBSC);

    // Constructor que recibe las direcciones de los contratos de tokens
    constructor(address _direccionTokenEthereum, address _direccionTokenBSC) {
        direccionTokenEthereum = _direccionTokenEthereum;
        direccionTokenBSC = _direccionTokenBSC;
    }

    // Función para intercambiar tokens ERC20 por tokens BEP20
    function intercambiarTokens(uint256 cantidadEthereum) external {
        // Transferir tokens ERC20 desde la cuenta del remitente al contrato
        require(IERC20Ethereum(direccionTokenEthereum).transferFrom(msg.sender, address(this), cantidadEthereum), "Transferencia ERC20 fallida");

        // Calcular la cantidad de tokens a recibir en BSC (asumiendo una tasa de cambio 1:1)
        uint256 cantidadBSC = cantidadEthereum;

        // Transferir tokens BEP20 a la cuenta del remitente
        require(IERC20BSC(direccionTokenBSC).transfer(msg.sender, cantidadBSC), "Transferencia BEP20 fallida");

        // Emitir evento de intercambio realizado
        emit IntercambioRealizado(msg.sender, cantidadEthereum, cantidadBSC);
    }
    // Función para permitir que el contrato gaste tokens ERC20
    function aprobarGastoERC20(uint256 cantidad) external {
        // Asegurarse de que el remitente sea el propietario del token ERC20
        require(msg.sender == direccionTokenEthereum, "No autorizado");

        // Aprobar al contrato para gastar tokens ERC20
        require(IERC20Ethereum(direccionTokenEthereum).approve(address(this), cantidad), "Aprobacion fallida");
    }
    
    // Función para consultar el saldo de tokens ERC20 en el contrato
    function saldoERC20() external view returns (uint256) {
        return IERC20Ethereum(direccionTokenEthereum).balanceOf(address(this));
    }

    // Función para consultar el saldo de tokens BEP20 en el contrato
    function saldoBEP20() external view returns (uint256) {
        return IERC20BSC(direccionTokenBSC).balanceOf(address(this));
    }
}
