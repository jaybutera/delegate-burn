const QD = artifacts.require('QueueDelegate')
const BurnableERC20 = artifacts.require('BurnableERC20')

contract('Linked list test', accounts => {
   let delegate
   let token

   it('Should add 3 stakers to list', async () => {
      token    = await BurnableERC20.new(1000, { from:accounts[0] })
      delegate = await QD.new(token.address)

      // Give stakers tokens
      token.mint(accounts[1], 100, { from: accounts[0] })
      token.mint(accounts[2], 100, { from: accounts[0] })
      token.mint(accounts[3], 100, { from: accounts[0] })

      // Approve delegate staking
      token.approve(delegate.address, 100, { from: accounts[1] })
      token.approve(delegate.address, 100, { from: accounts[2] })
      token.approve(delegate.address, 100, { from: accounts[3] })

      // Join delegate staking
      delegate.join(100, { from: accounts[1] })
      delegate.join(50,  { from: accounts[2] })
      delegate.join(25,  { from: accounts[3] })

      // Checks
      assert.equal(await delegate.length(), 3)
      assert.equal( (await delegate.get(accounts[1])).toNumber(), 100)
      assert.equal( (await delegate.get(accounts[2])).toNumber(), 50)
      assert.equal( (await delegate.get(accounts[3])).toNumber(), 25)
   })

   it('Should remove 3 stakers from list', async () => {
      delegate.withdraw({from: accounts[1]})
      delegate.withdraw({from: accounts[2]})
      delegate.withdraw({from: accounts[3]})

      assert.equal(await delegate.length(), 0)
   })
})
