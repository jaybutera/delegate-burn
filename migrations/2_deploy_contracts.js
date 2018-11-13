const QD = artifacts.require('QueueDelegate')
const BSB = artifacts.require('BurnableStakeBank')
const TR  = artifacts.require('TokenRegistry')
const BurnableERC20 = artifacts.require('BurnableERC20')
const Reward = artifacts.require('Reward')

const co2knCap = 100000
const minStake = 1

module.exports = async (deployer) => {
   deployer.deploy(BurnableERC20, co2knCap)  .then( tkn => {
   deployer.deploy(TR)                       .then( tr => {
   deployer.deploy(BSB, tr.address, minStake).then( bsb => {
   deployer.deploy(QD, bsb.address)          .then( qd => {
   deployer.deploy(Reward, qd.address)

   // QD contract needs ownership of BSB
   bsb.transferOwnership(qd.address)
   // Register co2kn in token registry
   tr.setToken('test', tkn.address)
   })
   })
   })
   })
}
