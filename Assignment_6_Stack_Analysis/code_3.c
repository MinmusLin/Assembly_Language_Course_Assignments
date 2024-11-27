int inner_fun(int a, int b) {
	return a + b;
}

int outer_fun(int a, int b) {
	int c = inner_fun(a, b);
	return c * c;
}

int main() {
	int n = outer_fun(1, 2);

	return 0;
}