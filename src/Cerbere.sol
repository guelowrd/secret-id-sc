// SPDX License Identifier: MIT

pragma solidity 0.8.19;

import {Halo2Verifier} from "./Halo2Verifier.sol";

contract Cerbere {
    error Cerbere__InvalidProof();

    Halo2Verifier public immutable i_halo2Verifier;

    struct Result {
        uint256 resultValue;
        uint256 confidenceScore;
    }

    event NewProofVerifiedAndResultAdded(
        address indexed proofSender,
        uint256 resultValue,
        uint256 confidenceScore
    );

    mapping(address user => Result result) private s_users_results;

    constructor(Halo2Verifier _verifier) {
        i_halo2Verifier = _verifier;
    }

    function submitFullResultsAndProof(
        uint256[] calldata fullResults,
        bytes memory proof
    ) public {
        // Verify EZKL proof.
        require(i_halo2Verifier.verifyProof(proof, fullResults));

        // Update the users' results dict
        Result memory result = _extractSuccinctResult(fullResults);
        s_users_results[msg.sender] = result;

        // Emit the New Entry event. All of these events will be indexed on the client side in order
        // to construct the leaderboard as opposed to storing the entire leader board on the blockchain.
        emit NewProofVerifiedAndResultAdded(
            msg.sender,
            result.resultValue,
            result.confidenceScore
        );
    }

    function _extractSuccinctResult(
        uint256[] memory fullResult
    ) private pure returns (Result memory succinctResult) {
        uint256 maxValue = 0;
        uint256 maxIndex = 0;
        for (uint256 i = 0; i < fullResult.length; i++) {
            if (fullResult[i] > maxValue) {
                maxValue = fullResult[i];
                maxIndex = i;
            }
        }
        succinctResult = Result(maxIndex, maxValue);
    }
}
