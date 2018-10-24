interface IDelegate {
    function join public (uint256 stake_amount);
    function withdraw public ();
    function withdraw_some public (uint256 stake_amount);
}
