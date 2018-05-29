const Sample = artifacts.require("./Sample.sol");
const GetCode = artifacts.require("./GetCode.sol");
const LiveFactory = artifacts.require("./LiveFactory.sol");

const toBytes32 = require('./helpers/toBytes32');

contract('advanced deployment', function(accounts) {
    
    let sample; 
    let getcode; 
    let livefactory; 

    it("should deploy Sample with constructor input", async function() {
        sample = await Sample.new(7);
        getcode = await GetCode.new();
        livefactory = await LiveFactory.new(); 
        //Get the bytecode with the constructor
        let samplecode = sample.constructor.bytecode; 
 
        let _input = toBytes32(4);
        
        let newcode = samplecode + _input.toString().substring(2, _input.length);
        
        let newsample = await livefactory.deployCode(newcode);

        let result = newsample.logs[0].args.deployedAddress; 

        let newnum = await Sample.at(result).thenum.call(); 
        
        assert.strictEqual(newnum.toNumber(), 4, 'new contract not deployed correctly');

    });

    it("should deploy Sample with constructor input through artifacts object", async function() {
        let newlivefactory = await LiveFactory.new(); 
        //Go TRUFFLE!!
        let thesamplecode = Sample._json.bytecode;

        let _constructorInput = toBytes32(99);

        let newinput = thesamplecode + _constructorInput.toString().substring(2, _constructorInput.length); 

        let newsamplecontract = await newlivefactory.deployCode(newinput); 

        let newresult = newsamplecontract.logs[0].args.deployedAddress; 

        let num = await Sample.at(newresult).thenum.call(); 

        assert.strictEqual(num.toNumber(), 99, 'new contract not deployed correctly');

        
    })
}); 