/*
 * Copyright (c) 2018-2019, BEPAL
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the University of California, Berkeley nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

static const int GXC_OP_TRANSFER_OPERATION = 0;//转账
static const int GXC_OP_ACCOUNT_CREATE_OPERATION = 5;//创建账户
static const int GXC_OP_ACCOUNT_UPDATE_OPERATION = 6;//更新账户
static const int GXC_OP_ACCOUNT_TRANSFER_OPERATION = 9;//更新账户

static const int GXC_OP_ASSET_CREATE_OPERATION = 10;//创建资产

static const int GXC_OP_DIY_OPERATION = 35;//自定义操作
static const int GXC_OP_PROXY_TRANSFER_OPERATION = 73;//代理转账
static const int GXC_OP_CONTRACT_DEPLOY_OPERATION = 74;//合约部署
static const int GXC_OP_CONTRACT_CALL_OPERATION = 75;//调用合约
static const int GXC_OP_CONTRACT_UPDATE_OPERATION = 76;//更新合约
