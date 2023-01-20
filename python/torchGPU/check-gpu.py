import torch
import time

cuda0 = torch.device("cuda:0" if torch.cuda.is_available else "cpu")
b = torch.ones([20000,20000], dtype = torch.float64, device = cuda0)
time.sleep(10)

