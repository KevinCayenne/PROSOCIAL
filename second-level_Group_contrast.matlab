counter = 1; %% Define contrast number 
timeCourseC = 11; %% Define time coureses for loop (0:11) (12 - 1)
AllTC = 12; %% Define 12 time coureses
MDcondNum = 4; %% Define MD conditions num
EDcondNum = 7; %% Define ED conditions num
GroupNum = 2; %% Define Group conditons num
SitCount = MDcondNum + EDcondNum; %% 11 conditions

matlabbatch{1}.spm.stats.con.spmmat = {'/bml/Data/Bank5/PROS/Pilot_image/Convert_data/first_level_matrix/seconlevel_analysis/SPM.mat'};

for Contrast_Cond = 1:29 %% contrast conditions
	for TimeC = 0:timeCourseC
		switch Contrast_Cond 
			case 1 %% All MD contrasts (ALL_MD - Baseline) 12/1
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['ALLMD_' int2str(TimeC+1)];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = repmat([...
				    																	 repmat([...
				    																	 		 repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
				    																			],1,MDcondNum)... 
				    																	 zeros(1,AllTC*EDcondNum)...
				    															 		],1,GroupNum);
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
				    counter = counter + 1;
			case 2 %% All ED contrasts (ALL_ED - Baseline) 12/1
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['ALLED_' int2str(TimeC+1)];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = repmat([...
						    															 zeros(1,AllTC*MDcondNum)... 
						    															 repmat([...
						    															 		 repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
						    																	],1,EDcondNum)...
				    															 		],1,GroupNum);
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
				    counter = counter + 1;

			%% MD Group contrasts %%

			case 3 %% All GroupMD_1 (Y_MD - O_MD) 12/1
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['All GroupMD_1_' int2str(TimeC+1)];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights =[repmat([...
				    																	 repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
				    																	],1,MDcondNum)...
				    															 zeros(1,AllTC*EDcondNum)...
				    															 repmat([...
				    															 		 repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
				    															 		],1,MDcondNum)... 
				    															 zeros(1,AllTC*EDcondNum)];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
				    counter = counter + 1;
		    case 4 %% All GroupMD_2 (Y_MD - Baseline) 12/1
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['All GroupMD_2_' int2str(TimeC+1)];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [repmat([...
				    																	  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
				    																	 ],1,MDcondNum)...
				    															  zeros(1,AllTC*EDcondNum)... 
				    															  zeros(1,AllTC*MDcondNum)...
				    															  zeros(1,AllTC*EDcondNum)];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
				    counter = counter + 1;
			case 5 %% All GroupMD_3 (O_MD - Baseline) 12/1
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['All GroupMD_3_' int2str(TimeC+1)];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [zeros(1,AllTC*MDcondNum)...
				    															  zeros(1,AllTC*EDcondNum)... 
				    															  repmat([...
				    																	  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
				    																	 ],1,MDcondNum)...
				    															  zeros(1,AllTC*EDcondNum)];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
				    counter = counter + 1;
			case 6 %% All GroupMD_4 (O_MD - Y_MD) 12/1
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['All GroupMD_4_' int2str(TimeC+1)];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [repmat([...
				    																	 repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
				    																	],1,MDcondNum)... 
				    															 zeros(1,AllTC*EDcondNum)... 
				    															 repmat([...
				    															 		 repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
				    															 		],1,MDcondNum)...
				    															 zeros(1,AllTC*EDcondNum)];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
				    counter = counter + 1;

			%% ED Group contrasts %%

		    case 7 %% All GroupED_1 (Y_ED - O_ED) 12/1
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['All GroupED_1_' int2str(TimeC+1)];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights =[zeros(1,AllTC*MDcondNum)...
				    															 repmat([...
				    																	 repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
				    																	],1,EDcondNum)...
				    															 zeros(1,AllTC*MDcondNum)... 
				    															 repmat([...
				    															 		 repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
				    															 		],1,EDcondNum)... 
				    															 ];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
				    counter = counter + 1;
		    case 8 %% All GroupED_2 (Y_ED - Baseline) 12/1
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['All GroupED_2_' int2str(TimeC+1)];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [zeros(1,AllTC*MDcondNum)...
				    															  repmat([...
				    																	  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
				    																	 ],1,EDcondNum)...
				    															  zeros(1,AllTC*MDcondNum)...
				    															  zeros(1,AllTC*EDcondNum)];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
				    counter = counter + 1;
			case 9 %% All GroupED_3 (O_ED - Baseline) 12/1
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['All GroupED_3_' int2str(TimeC+1)];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [zeros(1,AllTC*MDcondNum)...
				    															  zeros(1,AllTC*EDcondNum)...
				    															  zeros(1,AllTC*MDcondNum)...
				    															  repmat([...
				    																	  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
				    																	 ],1,EDcondNum)...
				    															  ];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
				    counter = counter + 1;
			case 10 %% All GroupED_4 (O_ED - Y_ED) 12/1
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['All GroupED_4_' int2str(TimeC+1)];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [zeros(1,AllTC*MDcondNum)...
				    															  repmat([...
				    																	 repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
				    																	 ],1,EDcondNum)...
				    															  zeros(1,AllTC*MDcondNum)... 
				    															  repmat([...
				    															 		 repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
				    															 		 ],1,EDcondNum)...
				    															 ];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
				    counter = counter + 1;

			%% Situations contrasts %%
			case 11 %% All situations contrasts (no grouping) 132/11
				for ConCount1 = 1:SitCount
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['Situ_' int2str(TimeC+1)];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = repmat([...
				    																	 zeros(1,AllTC*(ConCount1-1))...
				    																	 repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
				    																	 zeros(1,AllTC*((MDcondNum+EDcondNum)-ConCount1))...
				    															 		],1,GroupNum);
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
				    counter = counter + 1;
				end

			case 12 %% Situations contrasts ( Y - O ) 132/11
				for ConCount1 = 1:SitCount
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['YO_Situ_' int2str(TimeC+1)];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [...
				    															  zeros(1,AllTC*(ConCount1-1))...
				    															  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
				    															  zeros(1,AllTC*((MDcondNum+EDcondNum)-ConCount1))...
				    															  zeros(1,AllTC*(ConCount1-1))...
				    															  repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
				    															  zeros(1,AllTC*((MDcondNum+EDcondNum)-ConCount1))...
				    															 ];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
				    counter = counter + 1;
				end

			case 13 %% Situations contrasts ( O - Y ) 132/11
				for ConCount1 = 1:SitCount
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['OY_Situ_' int2str(TimeC+1)];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [...
				    															  zeros(1,AllTC*(ConCount1-1))...
				    															  repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
				    															  zeros(1,AllTC*((MDcondNum+EDcondNum)-ConCount1))...
				    															  zeros(1,AllTC*(ConCount1-1))...
				    															  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
				    															  zeros(1,AllTC*((MDcondNum+EDcondNum)-ConCount1))...
				    															 ];
				    matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
				    counter = counter + 1;
				end

			%% One group contrast Young %%

			case 14 %% Y_PROS-PUR Sit (Y) 12/1 44
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['Y_PROS_PUR_Situ'];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [...
					    														  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
					    														  repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
					    														 ];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
					counter = counter + 1;

			case 15 %% Y_PROS-NEU Sit (Y) 12/1 45
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['Y_PROS_NEU_Situ'];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [...
					    														  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
					    														  zeros(1, AllTC)...
					    														  repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
					    														 ];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
					counter = counter + 1;

			case 16 %% Y_PROS-UNCOM Sit (Y) 12/1 46 
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['Y_PROS_UNCOM_Situ'];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [...
					    														  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
					    														  zeros(1, AllTC*2)... 
					    														  repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
					    														 ];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
					counter = counter + 1;

			case 17 %% Y_PUR-PROS Sit (Y) 12/1 47
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['Y_PUR_PROS_1Situ'];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [...
					    														  repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
					    														  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
					    														 ];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
					counter = counter + 1;

			case 18 %% Y_PUR-NEU Sit (Y) 12/1 48
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['Y_PUR_NEU_Situ'];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [...
																				  zeros(1, AllTC)...
					    														  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
					    														  repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
					    														 ];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
					counter = counter + 1;

			case 19 %% Y_UNCOM-PROS Sit (Y) 12/1 49
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['Y_UNCOM_PROS_Situ'];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [...
					    														  repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
					    														  zeros(1, AllTC*2)...
					    														  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
					    														 ];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
					counter = counter + 1;

			case 20 %% Y_UNCOM-PUR Sit (Y) 12/1 50
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['Y_UNCOM_PUR_Situ'];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [...
																				  zeros(1, AllTC)...
																				  repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
																				  zeros(1, AllTC)...
					    														  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
					    														 ];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
					counter = counter + 1;

			case 21 %% Y_UNCOM-NEU Sit (Y) 12/1 51
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['Y_UNCOM_NEU_Situ'];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [...
																				  zeros(1, AllTC*2)...
																				  repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
					    														  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
					    														 ];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
					counter = counter + 1;

			%% One group contrast Old %%

			case 22 %% O_PROS-PUR Sit (O) 12/1 52
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['O_PROS_PUR_Situ'];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [...
																				  zeros(1, AllTC*SitCount)...
					    														  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
					    														  repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
					    														 ];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
					counter = counter + 1;

			case 23 %% O_PROS-NEU Sit (O) 12/1 53
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['O_PROS_NEU_Situ'];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [...
																				  zeros(1, AllTC*SitCount)...
					    														  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
					    														  zeros(1, AllTC)...
					    														  repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
					    														 ];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
					counter = counter + 1;

			case 24 %% O_PROS-UNCOM Sit (O) 12/1 54
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['O_PROS_UNCOM_Situ'];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [...
																				  zeros(1, AllTC*SitCount)...
					    														  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
					    														  zeros(1, AllTC*2)... 
					    														  repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
					    														 ];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
					counter = counter + 1;

			case 25 %% O_PUR-PROS Sit (O) 12/1 55
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['O_PUR_PROS_1Situ'];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [...
																				  zeros(1, AllTC*SitCount)...
					    														  repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
					    														  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
					    														 ];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
					counter = counter + 1;

			case 26 %% O_PUR-NEU Sit (O) 12/1 56
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['O_PUR_NEU_Situ'];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [...
																				  zeros(1, AllTC*SitCount)...
																				  zeros(1, AllTC)...
					    														  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
					    														  repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
					    														 ];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
					counter = counter + 1;

			case 27 %% O_UNCOM-PROS Sit (O) 12/1 57
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['O_UNCOM_PROS_Situ'];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [...
																				  zeros(1, AllTC*SitCount)...
					    														  repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
					    														  zeros(1, AllTC*2)...
					    														  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
					    														 ];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
					counter = counter + 1;

			case 28 %% O_UNCOM-PUR Sit (O) 12/1 58
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['O_UNCOM_PUR_Situ'];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [...
																				  zeros(1, AllTC*SitCount)...
																				  zeros(1, AllTC)...
																				  repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
																				  zeros(1, AllTC)...
					    														  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
					    														 ];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
					counter = counter + 1;

			case 29 %% O_UNCOM-NEU Sit (O) 12/1 59
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.name = ['O_UNCOM_NEU_Situ'];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.weights = [...
																				  zeros(1, AllTC*SitCount)...
																				  zeros(1, AllTC*2)...
																				  repmat(1/timeCourseC,1,TimeC) repmat(-1,1,1) repmat(1/timeCourseC,1,timeCourseC-TimeC)...
					    														  repmat(-1/timeCourseC,1,TimeC) ones(1,1) repmat(-1/timeCourseC,1,timeCourseC-TimeC)...
					    														 ];
					matlabbatch{1}.spm.stats.con.consess{counter}.tcon.sessrep = 'none';
					counter = counter + 1;


		end
	end
end

matlabbatch{1}.spm.stats.con.delete = 0;

spm_jobman('run', matlabbatch)