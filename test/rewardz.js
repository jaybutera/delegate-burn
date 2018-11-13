const QD = artifacts.require('QueueDelegate')
const BSB = artifacts.require('BurnableStakeBank')
const TR  = artifacts.require('TokenRegistry')
const BurnableERC20 = artifacts.require('BurnableERC20')
const Reward = artifacts.require('Reward')

contract('Reward test', accounts => {
   let qd
   let token
   let bsb
   let tr
   let reward

   beforeEach( async () => {
      token    = await BurnableERC20.new(1000)
      tr       = await TR.new()
      bsb      = await BSB.new(tr.address, 1)
      qd       = await QD.new(bsb.address)
      reward   = await Reward.new(qd.address)
      bsb.transferOwnership( qd.address )

      await tr.setToken('test', token.address)
   })

   it('Should add 3 stakers to list', async () => {
      // Give staker tokens
      token.mint(accounts[1], 100, { from: accounts[0] })
      token.mint(accounts[2], 100, { from: accounts[0] })

      // Approve qd staking
      token.approve(bsb.address, 100, { from: accounts[1] })
      token.approve(bsb.address, 100, { from: accounts[2] })

      // Join qd staking
      qd.join(100, 'test', { from: accounts[1] })
      qd.join(50, 'test',  { from: accounts[2] })

      // Finally, reward (parameters are ignored)
      console.log( (await qd.length()).toNumber() )
      await reward.reward([], [])
      assert.equal((await qd.length()).toNumber(), 1)

      await reward.reward([], [])
      assert.equal((await qd.length()).toNumber(), 0)

      // Checks
      //assert.equal( (await qd.get(accounts[1])).toNumber(), 100)
      //assert.equal( (await qd.get(accounts[2])).toNumber(), 50)
   })
})
