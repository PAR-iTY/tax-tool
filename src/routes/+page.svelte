<script>
	import currency from 'currency.js';

    // svelte $runes for state management
	let total_tax = $state(currency(0).format());
	let year_income = $state(currency(0.01).value);

	// tax data
	const taxes = [
		[0, 15600, currency(0.105, { precision: 3 }).value],
		[15600, 53500, currency(0.175, { precision: 3 }).value],
		[53500, 78100, currency(0.3).value],
		[78100, 180000, currency(0.33).value],
		[180000, Infinity, currency(0.39).value]
	];

	// calculate tax for a given bracket
	const calcTax = (bracket, rate) => {
		// bracket may be a decimal
		return currency(bracket).multiply(rate, { precision: 3 }).value;
	};

	const revealTax = () => {
		document.querySelector('#reveal').classList.remove('invisible');
	};

	const totalTax = () => {
		console.log('user_income:\n', year_income);

		// filter out tax brackets that don't apply
		const income_taxes = taxes.filter((bracket) => bracket[0] < year_income);
		console.log('income_taxes:\n', income_taxes);

		// get top applicable tax bracket
		const top_bracket = income_taxes
			.filter((bracket) => bracket[1] > year_income && bracket[0] < year_income)
			.flat();

		// calculate the remainder of income that the top tax rate applies to
		const remainder = calcTax(
			currency(year_income).subtract(top_bracket[0]).value,
			currency(top_bracket[2], { precision: 3 }).value
		);

		// check that the top bracket was not the only bracket before proceeding
		// i.e. check that income is more than $15,600
		if (income_taxes.length === 1) {
			console.log('only one tax bracket applies');

            // update total
            total_tax = currency(remainder).format();

			// reveal to user
			revealTax();

			// exit early
			return;
		}

		// calculate the tax for brackets that income exceeds
		const brackets_tax = income_taxes
			.filter((bracket) => bracket[1] < year_income)
			.map((bracket) =>
				calcTax(
					currency(bracket[1]).subtract(bracket[0]).value,
					currency(bracket[2], { precision: 3 }).value
				)
			);

		// sum all bracket tax values
		const sum_brackets = brackets_tax.reduce((acc, current) => acc + current, 0);

        // update total
		total_tax = currency(remainder).add(sum_brackets).format();

		// reveal income tax calculation
		revealTax();
	};
</script>

<main
	class="flex
    min-h-screen
    flex-col items-center justify-center
    border-pink-500
    bg-gray-300
    p-4
    px-4 py-2 text-center font-mono font-bold text-indigo-900"
>
	<h1 class=" m-2 block border-b text-2xl">Hnry Tax Tool</h1>
	<label class="m-2">
		Enter a yearly income:
		<input
            id="user_income"
			class="block rounded border-pink-500 bg-blue-100 px-0 py-1 text-center font-bold hover:bg-blue-200"
			type="number"
			placeholder="yearly income"
			step="0.01"
			min="0.01"
            bind:value={year_income}
		/>
	</label>
	<button
		onclick={totalTax}
		class="mb-2 block cursor-pointer rounded bg-indigo-900 px-2 py-2 font-bold text-white hover:bg-white hover:text-indigo-900"
	>
		Calculate tax
	</button>
	<div id="reveal" class="invisible mt-2 border-t border-pink-500 p-2 text-xl">
		<p>Total tax:</p>
		<p class="mt-2 px-1 rounded bg-indigo-900 text-white" id="total_tax">{total_tax}</p>
	</div>
</main>
