const QD = artifacts.require('QueueDelegate')
const BSB = artifacts.require('BurnableStakeBank')
const TR  = artifacts.require('TokenRegistry')
const BurnableERC20 = artifacts.require('BurnableERC20')
const Reward = artifacts.require('Reward')

const co2knCap = 100000
const minStake = 1
const personal = '0xd2bAbA039B9Db47F3DC0917D20CAA0F3F31ccB0A'
//const personal = '0x73aD92832c2Feae81d43bad6DcD905237C59A0D5'

module.exports = async (deployer, n, accs) => {
   console.log(accs)
   deployer.deploy(BurnableERC20, co2knCap)  .then( tkn => {
   deployer.deploy(TR)                       .then( tr => {
   deployer.deploy(BSB, tr.address, minStake).then( bsb => {
   deployer.deploy(QD, bsb.address)          .then( qd => {
   //deployer.deploy(Reward, qd.address)
   //deployer.deploy(Reward).then( r => r.set(qd.address) )
   console.log('token addr: ' + tkn.address)
   console.log('bsb addr: ' + bsb.address)
   console.log('qd addr: ' + qd.adress)

   const rewardContract = Reward.at("0x000000000000000000000000000000000000000A")
   rewardContract.set(qd.address)

   // QD contract needs ownership of BSB
   bsb.transferOwnership(qd.address)
   // Register co2kn in token registry
   tr.setToken('test', tkn.address).then(res => console.log('token arg: ' + JSON.stringify(res.logs[0].args) ))
   // Transfer ownership to personal account for testing
   tkn.transferOwnership(personal)
   console.log('cmon')
   })
   })
   })
   })
}
