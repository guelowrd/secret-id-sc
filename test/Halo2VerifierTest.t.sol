// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployCerbereAndVerifier} from "../script/DeployCerbereAndVerifier.s.sol";
import {Halo2Verifier} from "../src/Halo2Verifier.sol";
import {Cerbere} from "../src/Cerbere.sol";

contract Halo2VerifierTest is Test {
    DeployCerbereAndVerifier public deployer;
    Halo2Verifier public verifier;
    Cerbere public cerbere;

    function setUp() public {
        deployer = new DeployCerbereAndVerifier();
        (verifier, cerbere) = deployer.run();
    }

    function testSubmitProof() public {
        string[] memory inputs = new string[](1);
        inputs[0] = "./test/fetch_proof.sh";
        bytes memory proof = vm.ffi(inputs);
        uint256[] memory fullResult = new uint256[](10);
        fullResult[
            0
        ] = 14862421007915475989965712036697994912225307843929588082562953761253900498178;
        fullResult[
            1
        ] = 6702517552381689275391286093291595204215436906685765648578203439470395976581;
        fullResult[
            2
        ] = 7412995982203958388484705883858346239411504119174514625336285980297648779973;
        fullResult[
            3
        ] = 19482088039539124111620018305898271303948390090899364430420822660926038421542;
        fullResult[
            4
        ] = 11265168825382726180194655409118894101446069098547315495167030996634077888876;
        fullResult[
            5
        ] = 6500642535236140281856754861110320517954937811058106686509438954206035692213;
        fullResult[
            6
        ] = 7105791664273504956176032200397737246629220685455444389372450738112422066237;
        fullResult[
            7
        ] = 7053221943172318274055986892153972211741607959578214252349674643546870330084;
        fullResult[
            8
        ] = 21878778669162923689284093410069643982617378689656665248218147482496136901749;
        fullResult[
            9
        ] = 14203655383687094483690730757258096370075703975515266376065843255113691951310;

        verifier.verifyProof(proof, fullResult);
        assert(true);
    }
}
